defmodule ExAwsConf.Builder do
  require EEx

  alias ExAwsConf.Utils

  def run(organization_account_id, src_dir, dest_dir, output_format, mfa_serial, role_session_name) do
    artifacts = 
      src_dir |> 
      fetch_src_files |> 
      Enum.map( &( build_one(&1, organization_account_id, dest_dir, output_format, mfa_serial, role_session_name) ) )

    %{status: :ok, artifacts: artifacts}
  end

  defp fetch_src_files(src_dir) do
    case File.dir?(src_dir) do
      true -> src_dir |> File.ls! |> Enum.filter( &( &1 |> String.match?(~r/.*.csv/) ) ) |> Enum.map( &(Path.join(src_dir, &1)) )
      _ -> raise "oops #{src_dir} not found or invalid..."
    end
  end

  defp build_one(src_csv_file_path, organization_account_id, dest_dir, output_format, mfa_serial, role_session_name) do

    contexts = src_csv_file_path |> 
    File.stream! |> 
    CSV.decode!(separator: ?,, headers: [ :account_id, :email_address, :role_name, :profile_name, :display_name ]) |> 
    Enum.map( 
      &(
        Map.merge(
          &1, 
          %{
            role_arn: to_iam_role_arn(Map.fetch!(&1,:account_id), Map.fetch!(&1, :role_name)),
            switch_role_url: to_switch_role_url(Map.fetch!(&1, :display_name), Map.fetch!(&1, :role_name), Map.fetch!(&1, :account_id), "FAD791")
           }
        )
      )
    )

    config_dest_path = aws_config_file_path(src_csv_file_path, ".csv", dest_dir)
  
    # build aws/config
    Utils.Logger.debug("Mkdir for #{config_dest_path}...")
    config_dest_path |> Path.dirname |> File.mkdir_p!
    Utils.Logger.debug("Building #{src_csv_file_path} aws-cli config ...")
    aws_config_content = build_aws_config(contexts, output_format, mfa_serial, role_session_name)
    File.write(config_dest_path, aws_config_content)

    # build switch-role-link.md
    switch_role_link_md_dest_path = aws_switch_role_link_md_path(src_csv_file_path, ".csv", dest_dir)
    Utils.Logger.debug("Mkdir for #{switch_role_link_md_dest_path}...")
    switch_role_link_md_dest_path |> Path.dirname |> File.mkdir_p!
    Utils.Logger.debug("Building #{src_csv_file_path} switch-role-link.md ...")
    switch_role_link_md_content = build_aws_switch_role_link_md(contexts, organization_account_id)
    File.write(switch_role_link_md_dest_path, switch_role_link_md_content)

    %{src: src_csv_file_path, aws_config: config_dest_path, switch_role_link_md: switch_role_link_md_dest_path}
  end

  EEx.function_from_file(
    :def, 
    :build_aws_config, 
    "lib/templates/aws_config.eex", 
    [:contexts, :output_format, :mfa_serial, :role_session_name]
  )
  EEx.function_from_file(
    :def, 
    :build_aws_switch_role_link_md, 
    "lib/templates/aws_switch_role_link_md.eex",
    [:contexts, :organization_account_id]
  )

  defp aws_config_file_path(src_path, src_ext, dest_dir) do
    case File.dir?(dest_dir) do
      true -> Path.join([dest_dir, Path.basename(src_path, src_ext), "config"])
      _ -> raise "oops #{dest_dir} does not found or invalid.."
    end
  end

  defp aws_switch_role_link_md_path(src_path, src_ext, dest_dir) do
    case File.dir?(dest_dir) do
      true -> Path.join([dest_dir, Path.basename(src_path, src_ext), "switch_role_link.md"])
      _ -> raise "oops #{dest_dir} does not found or invalid.."
    end
  end

  defp to_iam_role_arn(role_name, account_id) do
    "arn:aws:iam::#{account_id}:role/#{role_name}"
  end

  defp to_switch_role_url(display_name, role_name, account_id, color_code) do
    "https://signin.aws.amazon.com/switchrole?roleName=#{role_name}&account=#{account_id}&displayName=#{display_name}&color=#{color_code}"
  end
end
  