/* resource "proxmox_lxc" "packer_builder" { # https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/resources/lxc.md
  target_node     = "glacier"
  vmid            = 800
  hostname        = "packer-builder"
  ostemplate      = "glacier_replicated_v1:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  password        = "packer"
  unprivileged    = true
  description     = <<-EOT
    ## Additional manual configuration 
    In the `/etc/pve/lxc/<vm-id>.conf` file add the following lines.
    ```txt
    lxc.cgroup2.devices.allow: c 10:200 rwm
    lxc.mount.entry: /dev/net dev/net none bind,create=dir
    ```
    After the container is created, run the following commands to setup the container and join it to the zerotier configuration network.
    ```bash
    apt-get update && apt-get upgrade -y && apt-get install gpg curl git -y
    wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    apt-get update && apt-get install packer -y
    curl -s https://install.zerotier.com | sudo bash
    zerotier-cli join f82d90b853898206
    ```
    Also make sure a ssh-key exists, otherwise generate a new one with `ssh-keygen -a`
  EOT
  ssh_public_keys = <<-EOT
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDr6x43EDcTx7reYx5SbDVKgRot9s7cnY0oeNsIqqE552xnKI58gXZj1QWCm5Vq9Schf+vSIb5kRbHXueD4VcdAoxPm0ZP53doOZY1Rt/6G0j8o4fhmyeisksvPI5XwmEuBlUketbvDnyqCGUwuL9ngtl4t64vumjrs2SFN7afO6NREz20BG8Igqg7SWULUVws/OZWlS7wJg2jkm1NrI4TZBifa+alk+8Cp8SF5m8wxnAhHA+n6S3KMk0z1pCnVeDc6L6cZjYeVfX/xTz4hwrYuDV6NTkl5hyQo2PsZ4R+lwWkMFXGPSPdrfgql95hknOzZnRbTxsJ1P3U9C8y/E1CDLVLMxRfFqYbZbfksvqsVwL0rwsuBsBXveV/aTvwsjLx+5kk/AjA0pwRTpC2L2wPlzXFhVopgIU0sn/T09imPdLxzg86lkKIGky2+rc3kssg9tUMSAGxm54Gk7zZdRX9UsfzBrtdPuQzeKyLHMbV8VKuzp6EHWMois6i+sPNL39U= contact@jakoberpf.de
  EOT

  features {
    nesting = true
  }

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "dhcp"
  }
} */
