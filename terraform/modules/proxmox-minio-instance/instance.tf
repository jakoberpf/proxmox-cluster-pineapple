resource "proxmox_vm_qemu" "this" {
  name        = "${var.compartment}-${var.name}-${random_string.deployment_id.result}"
  vmid        = var.id
  target_node = "backup"

  # Clone from debian-cloudinit template
  clone   = var.instance_template
  os_type = "cloud-init"

  # Cloud init options
  ipconfig0 = "ip=${var.network_ip},gw=${var.network_gateway}"
  cicustom  = "user=local:snippets/cloud-init-minio-standalone-${random_string.deployment_id.result}.yml"

  memory = var.instance_memory
  cores  = var.instance_cpus
  agent  = 1

  # Set the boot disk paramters
  bootdisk = "virtio0"
  scsihw   = "virtio-scsi-pci"

  disk {
    size    = "19660M"
    type    = "virtio"
    storage = "local-lvm"
  }

  # Set the network
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Ignore changes to the network
  ## MAC address is generated on every apply, causing
  ## TF to think this needs to be rebuilt on every apply
  lifecycle {
    ignore_changes = [
      network
    ]
  }
}
