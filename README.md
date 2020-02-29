# README

Hello guys.

[ex_awsconf](https://hexdocs.pm/ex_awsconf/0.1.0) is a simple Elixir cli tool for generating aws-cli config.<br/>
(and also generating AWS switch role login links markdown file.)


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


