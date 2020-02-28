defmodule AprofCli do
  def main(args \\ []) do
    IO.inspect(args)

    src_dir = Enum.at(args, 0)
    IO.puts(src_dir)
    dest_dir = Enum.at(args, 1)
    role_session_name = Enum.at(args, 2)
    mfa_serial = Enum.at(args, 3)
    output_format = Enum.at(args, 4)

    # build
    AwsTemplateBuilder.run(src_dir, dest_dir, output_format, mfa_serial, role_session_name)
    IO.puts("done.")
  end
end
