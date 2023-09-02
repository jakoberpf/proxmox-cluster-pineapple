# Source the cloud-init-config file
data "template_file" "this" {
  template = file("${path.module}/templates/cloud-init.cloud_config.tpl") # sudo cloud-init schema --system

  vars = {
    automation_user_password    = var.automation_user_password
    github_runner_user_password = var.github_runner_user_password
    ssh_key                     = var.ssh_authorized_keys
  }
}

# Transfer the file to the Proxmox Host
resource "remote_file" "this" {
  path        = "/var/lib/vz/snippets/cloud_init_${var.id}-${random_string.deployment_id.result}.yml"
  content     = data.template_file.this.rendered
  permissions = "0644"
}

# Create virtual machine
resource "proxmox_vm_qemu" "this" {
  ## Wait for the cloud-config file to exist
  depends_on = [
    data.template_file.this,
    remote_file.this
  ]

  name        = "${var.name}-${random_string.deployment_id.result}"
  vmid        = var.id
  target_node = var.target_node

  # Clone from debian-cloudinit template
  clone   = var.instance_template
  os_type = "cloud-init"

  # Cloud init options
  ipconfig0 = "ip=dhcp"
  cicustom  = "user=local:snippets/cloud_init_${var.id}-${random_string.deployment_id.result}.yml"

  memory = var.instance_memory
  cores  = var.instance_cpus
  agent  = 1

  # Set the boot disk paramters
  bootdisk = "virtio0"
  scsihw   = "virtio-scsi-pci"

  disk {
    size    = var.instance_disk
    type    = "virtio"
    storage = "glacier_disks_v1"
  }

  # Set the network
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Serial interface of type socket is used by xterm.js
  # You will need to configure your guest system before being able to use it
  serial {
    id   = 0
    type = "socket"
  }

  # Ignore changes to the network
  ## MAC address is generated on every apply, causing
  ## TF to think this needs to be rebuilt on every apply
  lifecycle {
    ignore_changes = [
      network
    ]
    replace_triggered_by = [
      remote_file.this
    ]
  }
}
