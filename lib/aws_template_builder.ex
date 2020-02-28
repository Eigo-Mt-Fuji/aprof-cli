defmodule AwsTemplateBuilder do

  def run(src_dir, dest_dir, output_format, mfa_serial, role_session_name) do
    #
    fetch_src_files(src_dir) |> Enum.each( &( &1 |> build_one(dest_dir, output_format, mfa_serial, role_session_name) ) )
  end

  defp fetch_src_files(src_dir) do
    case File.dir?(src_dir) do
      true -> src_dir |> File.ls! |> Enum.filter( &( &1 |> String.match?(~r/.*.csv/) ) ) |> Enum.map( &(Path.join(src_dir, &1)) )
      _ -> raise "oops #{src_dir} not found or invalid..."
    end
  end

  defp build_one(src_csv_file_path, dest_dir, output_format, mfa_serial, role_session_name) do
    config_dest_path = aws_config_file_path(src_csv_file_path, ".csv", dest_dir)
    switch_role_link_md_path = aws_switch_role_link_md_path(src_csv_file_path, ".csv", dest_dir)

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
  
    bindings = [ 
      contexts: contexts, 
      output_format: output_format, 
      mfa_serial: mfa_serial, 
      role_session_name: role_session_name, 
      current_timestamp: :os.system_time(:millisecond) 
    ]
    # build aws/config
    IO.puts("Building #{src_csv_file_path} aws-cli config ...")
    aws_config_content = EEx.eval_file( "./lib/template/aws_config.eex", bindings, [] )
    File.write(config_dest_path, aws_config_content)

    # build switch-role-link.md
    IO.puts("Building #{src_csv_file_path} switch-role-link.md ...")
    switch_role_link_md_content = EEx.eval_file( "./lib/template/aws_switch_role_link_md.eex", bindings, [] )
    File.write(switch_role_link_md_path, switch_role_link_md_content)

    :ok
  end

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
  