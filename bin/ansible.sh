#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Run terraform apply
cd $GIT_ROOT/ansible

# Make sure virtual environment is activated
source .venv/bin/activate

# Run ansible
ansible-playbook plays/main.yaml
