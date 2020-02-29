defmodule AprofCli do
  def main(args \\ []) do

    [organization_account_id, src_dir, dest_dir, role_session_name, mfa_serial, output_format]  = args

    AwsTemplateBuilder.run(organization_account_id, src_dir, dest_dir, output_format, mfa_serial, role_session_name) |> 
    Jason.encode!(pretty: true) |> IO.puts
  end
end
