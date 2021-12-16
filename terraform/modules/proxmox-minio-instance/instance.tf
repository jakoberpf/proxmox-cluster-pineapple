# Source the cloud-init-config file
data "template_file" "this" {
  template = file("${path.module}/templates/cloud-init.cloud_config.tpl")

  vars = {
    ssh_key              = var.ssh_authorized_keys
    ceph_client_admin    = var.ceph_admin_keyring
    cloudflare_api_key   = var.cloudflare_api_key
    minio_admin_user     = var.minio_glacier_admin_access_key
    minio_admin_key      = var.minio_glacier_admin_secret_key
    zerotier_network_id  = var.zerotier_network_id
    zerotier_public_key  = zerotier_identity.this.public_key
    zerotier_private_key = zerotier_identity.this.private_key
  }
}

# Transfer the file to the Proxmox Host
resource "null_resource" "this" {
  depends_on = [
    data.template_file.this
  ]
  connection {
    type        = "ssh"
    user        = "root"
    private_key = var.ssh_secret_key
    host        = "10.147.19.79"
  }

  provisioner "file" {
    content     = data.template_file.this.rendered
    destination = "/var/lib/vz/snippets/cloud_init_ubuntu_minio-${random_string.deployment_id.result}.yml"
  }
}

# Create virtual machine
resource "proxmox_vm_qemu" "this" {
  ## Wait for the cloud-config file to exist
  depends_on = [
    null_resource.this
  ]

  name        = "${var.compartment}-${var.name}-${random_string.deployment_id.result}"
  vmid        = var.id
  target_node = "backup"

  # Clone from debian-cloudinit template
  clone   = var.instance_template
  os_type = "cloud-init"

  # Cloud init options
  ipconfig0 = "ip=${var.network_ip},gw=${var.network_gateway}"
  cicustom  = "user=local:snippets/cloud_init_ubuntu_minio-${random_string.deployment_id.result}.yml"

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
