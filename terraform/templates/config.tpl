Host *
  ForwardAgent yes
  StrictHostKeyChecking no

Host bastion
  Hostname 10.147.19.79
  User root
  IdentityFile /Users/jakoberpf/Code/jakoberpf/proxmox-backup/.ssh/automation

Host proxmox-backup
  Hostname 10.147.19.79
  User root
  IdentityFile /Users/jakoberpf/Code/jakoberpf/proxmox-backup/.ssh/automation

%{ for index, id in node-id ~}
Host ${id}
  Hostname ${node-ip[index]}
  User ${node-user[index]}
  IdentityFile ${node-key}

%{ endfor ~}
