# AWS Resources

We need to export some environment variables so that the BOSH CLI knows about your AWS setup.

The environment variables will be exported in the current terminal session. If you start a new session you will need to export them again.

## If you're using Linux/MacOS/Git Bash on Windows

* Run `eval "$(cat bosh_env_vars)"` to make the environment variables describing your AWS VPC available to the BOSH CLI
* Give your bosh-key.pem file appropriate permissions with `chmod 0600 bosh-key.pem`

## If you're using  Windows Command Prompt

* Run `call bosh_env_vars.bat` to make the environment variables describing your AWS VPC available to the BOSH CLI

## Verify your environment

Once you've setup your environment, you can verify your environment by executing the following:

```
$ bosh env
Using environment '<ip-address>' as client 'admin'

Name               bosh-training-<student-name>
UUID               e3957fa4-1471-44a6-9a97-1579c99c64fc
Version            273.0.0 (00000000)
Director Stemcell  -/0.3
CPI                warden_cpi
Features           config_server: enabled
                   local_dns: enabled
                   power_dns: disabled
                   snapshots: disabled
User               admin

Succeeded
```

Please proceed to the training materials and enjoy :)
