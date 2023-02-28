#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)

terraform_version="1.1.5"
python_version="3.9.6"
ansible_version="4.8.0"

python3 -m venv .venv/terraform
python3 -m venv .venv/ansible

source .venv/terraform/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade checkov

source .venv/ansible/bin/activate
python -m pip install --upgrade pip
python -m pip install --upgrade ansible==$ansible_version
python -m pip install --upgrade jmespath dnspython netaddr
ansible-galaxy install systemli.letsencrypt
