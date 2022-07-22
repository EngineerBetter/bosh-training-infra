#!/usr/bin/env bash
set -euo

linux_env_filename=bosh_env_vars
windows_env_filename=${linux_env_filename}.bat

mkdir -p student-packs/student-packs
cp bosh-training-infra/student-packs/README.md ./

echo "$PRIVATE_KEY" > bosh-key.pem
chmod 0400 bosh-key.pem

jq -c '.students[]' students-terraform-state/metadata | while read student; do
    student_name=$( jq -r '.name' <<< "$student" )
    student_ip=$( jq -r '.external_ip' <<< "$student" )
    # please keep the tabs below this line - required for heredoc
    cat <<-EOF > $linux_env_filename
		export BOSH_CLIENT="admin"
		export BOSH_CLIENT_SECRET="$(bosh interpolate director-states/creds-${student_name}.yml --path=/admin_password)"
		export BOSH_ENVIRONMENT="${student_ip}"
		export BOSH_CA_CERT="$(bosh interpolate director-states/creds-${student_name}.yml --path=/director_ssl/ca)"
		export BOSH_GW_USER="vcap"
		export BOSH_GW_PRIVATE_KEY="\${PWD}/bosh-key.pem"
		EOF

    cat <<-EOF > $windows_env_filename
		set BOSH_CLIENT="admin"
		set BOSH_CLIENT_SECRET="$(bosh interpolate director-states/creds-${student_name}.yml --path=/admin_password)"
		set BOSH_ENVIRONMENT="${student_ip}"
		set BOSH_CA_CERT="$(bosh interpolate director-states/creds-${student_name}.yml --path=/director_ssl/ca)"
		set BOSH_GW_USER="vcap"
		set BOSH_GW_PRIVATE_KEY="\${PWD}/bosh-key.pem"
		EOF
tar -zcvf student-packs/student-packs/${student_name}.tgz bosh-key.pem $linux_env_filename $windows_env_filename README.md
done
