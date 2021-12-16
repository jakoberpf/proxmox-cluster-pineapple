#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)

cd $GIT_ROOT/terraform

terraform_version="1.1.5"

tfenv install $terraform_version
tfenv use $terraform_version

m1-terraform-provider-helper install hashicorp/template -v v2.2.0

cd $GIT_ROOT/ansible

python_version="3.9.6"
ansible_version="4.8.0"

# Create virtual environment
python -m venv .venv

# Activate virtual environment
source .venv/bin/activate

# Install ansible
pip3 install --upgrade pip
pip3 install ansible==$ansible_version
pip3 install jmespath dnspython netaddr

# Get roles from galaxy
ansible-galaxy install systemli.letsencrypt