#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Make sure virtual environment is activated
source $GIT_ROOT/.venv/ansible/bin/activate

# Run terraform apply
cd $GIT_ROOT/ansible

# Run ansible
ansible-playbook plays/main.yaml
