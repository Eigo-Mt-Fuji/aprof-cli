# README

[![hex.pm version](https://img.shields.io/hexpm/v/ex_awsconf.svg)](https://hex.pm/packages/ex_awsconf)
[![hex.pm](https://img.shields.io/hexpm/l/ex_awsconf.svg)](https://github.com/Eigo-Mt-Fuji/ex-awsconf/blob/master/LICENSE.md)

Simple cli-tool for generating aws config.<br/>
(and also generating AWS switch role login links markdown file.)


## Installation

If [available Docker](https://hub.docker.com/r/efgriver/ex-awsconf), the docker image can be installed by `docker pull efgriver/ex-awsconf` command on terminal.
 
If [available in Hex](https://hexdocs.pm/ex_awsconf), the package can be installed by adding `ex_awsconf` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_awsconf, "~> 0.1.2"}
  ] 
end
```

## Require 

* elixir version 1.9 (or later)
* erlang version 21 (or later)

## How to use

* Clone Repository and Get Dependencies 

```bash
$ git clone git@github.com:Eigo-Mt-Fuji/ex-awsconf.git
$ cd ex-awsconf/
$ mix deps.get
```

* Prepare csv file(with your aws accounts, save into files directory)

```bash
mkdir -p files/
cat <<EOF > files/my-accounts.csv
"<aws_account_id>","<root login e-mail address>","aws IAM-Role name","profile name(aws-cli )","display name(for browser)"
EOF
```

* Build escript

```bash
MIX_ENV=prod mix escript.build
```

* Prepare artifacts directory (results will be saved into this directory.)

```bash
rm -rf ./artifacts
mkdir -p ./artifacts
```

* Execute

```bash
./ex_awsconf <parent_aws_account_id> ./files ./artifacts json arn:aws:iam::<parenparent_aws_account_idt_account_id>:mfa/<user_name> <role_session_name>
```

  - with Docker.

```bash
docker run \
  -v $(pwd)/files:/usr/local/src/files:ro \
  -v $(pwd)/artifacts:/usr/local/src/artifacts:rw \
  efgriver/ex-awsconf:latest \
  <parent_aws_account_id> /usr/local/src/files /usr/local/src/artifacts <aws-cli default output format(e.g. json)>\
  arn:aws:iam::<parent_aws_account_id>:mfa/<user_name> \
  <role-session-name>
```

* Execute Output is JSON format like following.

```json
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
```

* aws-cli's config, markdown(for aws switch-role login) should be exists (per each csv file in files directory)

```bash
$ find -type f $(pwd)/artifacts
/Users/fujikawa/Documents/git/aprof-cli/artifacts/my-accounts/config
/Users/fujikawa/Documents/git/aprof-cli/artifacts/my-accounts/switch_role_link.md
```


