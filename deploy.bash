#!/usr/bin/env bash
set -euo pipefail

bosh create-env ~/workspace/bosh-deployment/bosh.yml \
    --state=state.json \
    --vars-store=creds.yml \
    -o ~/workspace/bosh-deployment/aws/cpi.yml \
    -o ~/workspace/bosh-deployment/external-ip-with-registry-not-recommended.yml \
    -o ~/workspace/bosh-deployment/bosh-lite.yml \
    -o ~/workspace/bosh-deployment/jumpbox-user.yml \
    -o ~/workspace/bosh-deployment/uaa.yml \
    -o ~/workspace/bosh-deployment/credhub.yml \
    -v director_name=bosh-training \
    -v internal_cidr="$TF_VAR_internal_cidr" \
    -v internal_gw=10.0.0.1 \
    -v internal_ip=10.0.0.6 \
    -v "access_key_id=${AWS_ACCESS_KEY_ID}" \
    -v "secret_access_key=${AWS_SECRET_ACCESS_KEY}" \
    -v region="$TF_VAR_region" \
    -v az="$TF_VAR_availability_zone" \
    -v default_key_name="$TF_VAR_key_name" \
    -v default_security_groups="[${TF_VAR_security_group_name}]" \
    --var-file private_key=/Users/tom/workspace/bosh-training-infra/terraform/secret/id_ed \
    -v subnet_id="$( terraform -chdir=terraform output -raw subnet_id )" \
    -v external_ip="$( terraform -chdir=terraform output -raw bosh_ip )"
