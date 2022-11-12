#!/usr/bin/env bash
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

# Make sure virtual environment is activated
source $GIT_ROOT/.venv/ansible/bin/activate

# Run ansible playbook
cd $GIT_ROOT/ansible
ansible-playbook plays/main.yaml
