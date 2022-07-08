# AWS Resources

We need to export some environment variables so that the BOSH CLI knows about your AWS setup.

The environment variables will be exported in the current terminal session. If you start a new session you will need to export them again.

## If you're using Linux/MacOS/Git Bash on Windows

* Run `eval "$(cat linux_env_filename)"` to make the environment variables describing your AWS VPC available to the BOSH CLI
* Give your bosh-key.pem file appropriate permissions with `chmod 0600 bosh-key.pem`

## If you're using  Windows Command Prompt

* Run `call linux_env_filename.bat` to make the environment variables describing your AWS VPC available to the BOSH CLI