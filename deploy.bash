#!/usr/bin/env bash
set -euo pipefail

bosh create-env ~/workspace/bosh-deployment/bosh.yml \
    --state=state.json \
    --vars-store=creds.yml \
    -o ~/workspace/bosh-deployment/aws/cpi.yml \
    -o ~/workspace/bosh-deployment/external-ip-with-registry-not-recommended.yml \
    -v director_name=bosh-training \
    -v internal_cidr=10.0.0.0/24 \
    -v internal_gw=10.0.0.1 \
    -v internal_ip=10.0.0.6 \
    -v "access_key_id=${AWS_ACCESS_KEY_ID}" \
    -v "secret_access_key=${AWS_SECRET_ACCESS_KEY}" \
    -v region=eu-west-2 \
    -v az=eu-west-2a \
    -v default_key_name=bosh-training-key \
    -v default_security_groups=[bosh] \
    --var-file private_key=/Users/tom/workspace/bosh-training-infra/terraform/secret/id_ed \
    -v subnet_id=subnet-06ca9b579b068b418 \
    -v external_ip=18.168.136.195