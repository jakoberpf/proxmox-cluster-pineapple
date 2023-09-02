#cloud-config

users:
  - name: automation-user
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    lock-passwd: false
    chpasswd: { expire: False }
    hashed_passwd: "${automation_user_password}"
    ssh_authorized_keys:
      - ${ssh_key}
  - name: github-runner
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    lock-passwd: false
    chpasswd: { expire: False }
    hashed_passwd: "${github_runner_user_password}"
    ssh_authorized_keys:
      - ${ssh_key}

packages:
  - curl

runcmd:
  # Enable Serial Interface
  - systemctl enable serial-getty@ttyS0.service
  - systemctl start serial-getty@ttyS0.service
  - sed -i 's/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="quiet console=tty0 console=ttyS0,115200"/' /etc/default/grub
  - update-grub
  # (optional) auto root login without password on serial console https://zain.mu/proxmox/serial-terminal/
  # Install Vagrant and VirtualBox
  - wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  - echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  - apt update && apt install vagrant virtualbox virtualbox-dkms -y
