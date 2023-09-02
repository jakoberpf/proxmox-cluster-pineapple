module "github_runner_ansible_role_proxmox" {
  source = "./modules/proxmox-github-runner-instance"
  providers = {
    proxmox  = proxmox
    zerotier = zerotier
    remote   = remote.glacier
  }
  id                          = 401
  name                        = "github-runner-ansible-role-proxmox"
  target_node                 = "glacier"
  instance_template           = "ubuntu-20.04-base" #"ubuntu-focal-server-cloudinit" # xw
  instance_cpus               = 2
  instance_memory             = 8192
  instance_disk               = "11468M"
  ssh_secret_key              = file("../.ssh/automation")
  ssh_authorized_keys         = var.authorized_keys
  automation_user_password    = "$6$rounds=4096$9QbxTj4TMPyZcQ3R$5cUvvYKgDYbTQcwGPwXDcPji/fclY2vPkZkVbbTRqQZ/Fj80XwUDR.p5DXzX84H0EdlSnF/RiYuWZfQb1srBk1"
  github_runner_user_password = "$6$rounds=4096$9QbxTj4TMPyZcQ3R$5cUvvYKgDYbTQcwGPwXDcPji/fclY2vPkZkVbbTRqQZ/Fj80XwUDR.p5DXzX84H0EdlSnF/RiYuWZfQb1srBk1"
}
