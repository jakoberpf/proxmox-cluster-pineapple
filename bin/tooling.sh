#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)

terraform_version="1.1.5"
python_version="3.9.6"
ansible_version="4.8.0"

python -m venv .venv/terraform
source .venv/terraform/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade checkov
python -m pip install --upgrade ansible==6.5.0

python -m venv .venv/ansible
source .venv/ansible/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade ansible==$ansible_version
python -m pip install --upgrade jmespath dnspython netaddr
ansible-galaxy install systemli.letsencrypt

# m1-terraform-provider-helper install hashicorp/template -v v2.2.0
