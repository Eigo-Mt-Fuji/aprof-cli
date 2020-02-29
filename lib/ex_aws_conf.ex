defmodule ExAwsConf do
  alias ExAwsConf.Utils.Builder
  @moduledoc """
  This is main module.
  This module also has a `main/1` function.
  """

  @doc """
  Start to build aws-config based passed on arguments.

  ## Parameters

    Following arguments are expected to specify as args.
    - organization_account_id: String that represents the top of aws account id of your organization
    - src_dir: String that represents the directory which having your aws accounts listing csv files. this tool will make aws-config based on list in csv file
      - each csv file should have follows attributes in each line.(Note: header is not required)
         - "aws_account_id","root login e-mail address","aws iam-role name","profile name(for aws-cli)","display name(for browser)"
    - dest_dir: String that represents the destination directory (aws-cli config switch-role login markdown will be exported into this directory.)
    - role_session_name: String that represents name of switch-role logined user on aws-cli 
    - mfa_serial: String that represents the aws your IAM user's MFA serial.
    - output_format: String that represents the aws-cli pre-defined output format like "json", "yaml"

  ## Examples

      iex> ExAwsConf.main("123456789012", "./files", "./artifacts", "json", "arn:aws:iam::123456789012:mfa/eigo.fujikawa", "eigo.fujikawa")
      {
        "artifacts": [
          {
            "aws_config": "./artifacts/my-accounts/config",
            "src": "./files/my-accounts.csv",
            "switch_role_link_md": "./artifacts/my-accounts/switch_role_link.md"
          },
          ..
        ],
        "status": "ok"
      }

  """
  @spec main(List.t()) :: String.t()
  def main(args \\ []) do

    [organization_account_id, src_dir, dest_dir, role_session_name, mfa_serial, output_format]  = args

    Builder.run(organization_account_id, src_dir, dest_dir, output_format, mfa_serial, role_session_name) |> 
    Jason.encode!(pretty: true) |> IO.puts
  end
end
