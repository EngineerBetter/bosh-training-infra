#!/usr/bin/env bash
set -euo pipefail

bosh create-env ~/workspace/bosh-deployment/bosh.yml \
    --vars-store=creds.yml \
    --state=state.json \
    --ops-file ~/workspace/bosh-deployment/aws/cpi.yml \
    --ops-file ~/workspace/bosh-deployment/bosh-lite.yml \
    --ops-file ~/workspace/bosh-deployment/jumpbox-user.yml \
    --ops-file ~/workspace/bosh-deployment/uaa.yml \
    --ops-file ~/workspace/bosh-deployment/credhub.yml \
    --ops-file ~/workspace/bosh-deployment/external-ip-with-registry-not-recommended.yml \
    --ops-file ~/workspace/bosh-deployment/external-ip-not-recommended-uaa.yml \
    --var director_name=bosh-training \
    --var internal_cidr="$TF_VAR_internal_cidr" \
    --var internal_gw=10.0.0.1 \
    --var internal_ip=10.0.0.6 \
    --var "access_key_id=${AWS_ACCESS_KEY_ID}" \
    --var "secret_access_key=${AWS_SECRET_ACCESS_KEY}" \
    --var region="$TF_VAR_region" \
    --var az="$TF_VAR_availability_zone" \
    --var default_key_name="$TF_VAR_key_name" \
    --var default_security_groups="[${TF_VAR_security_group_name}]" \
    --var-file private_key=/Users/tom/workspace/bosh-training-infra/terraform/secret/id_ed \
    --var subnet_id="$( terraform -chdir=terraform output -raw subnet_id )" \
    --var external_ip="$( terraform -chdir=terraform output -raw bosh_ip )"
