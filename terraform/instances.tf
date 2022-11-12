# module "minio_glacier" {
#   source = "./modules/proxmox-minio-instance"
#   providers = {
#     cloudflare = cloudflare
#     proxmox    = proxmox
#     remote     = remote.proxmox
#     zerotier   = zerotier
#   }
#   id                             = 110
#   name                           = "minio"
#   compartment                    = "glacier"
#   instance_template              = "ubuntu-focal-server-cloudinit"
#   instance_cpus                  = 2
#   instance_memory                = 8192
#   network_ip                     = "192.168.1.6/24"
#   network_gateway                = "192.168.1.1"
#   ssh_secret_key                 = file("../.ssh/automation")
#   ssh_authorized_keys            = var.authorized_keys
#   cloudflare_account_id          = var.cloudflare_account_id
#   cloudflare_zone_id             = var.cloudflare_zone_id
#   cloudflare_api_key             = var.cloudflare_api_key
#   zerotier_network_id            = var.zerotier_network_id_development
#   zerotier_ip_assignment         = "10.147.19.41"
#   ceph_admin_keyring             = var.ceph_admin_keyring
#   minio_glacier_admin_access_key = var.minio_glacier_admin_access_key
#   minio_glacier_admin_secret_key = var.minio_glacier_admin_secret_key
# }

# module "filebrowser_glacier" {
#   source = "./modules/proxmox-filebrowser-instance"
#   providers = {
#     proxmox  = proxmox
#     zerotier = zerotier
#   }
#   id                     = 111
#   name                   = "filebrowser"
#   compartment            = "glacier"
#   instance_template      = "ubuntu-focal-server-cloudinit"
#   instance_cpus          = 2
#   instance_memory        = 8192
#   network_ip             = "192.168.1.7/24"
#   network_gateway        = "192.168.1.1"
#   ssh_secret_key         = file("../.ssh/automation")
#   ssh_authorized_keys    = var.authorized_keys
#   zerotier_network_id    = var.zerotier_network_id_development
#   zerotier_ip_assignment = "10.147.19.40"
#   ceph_admin_keyring     = var.ceph_admin_keyring
# }

# module "samba_glacier" {
#   source = "./modules/proxmox-samba-instance"
#   providers = {
#     proxmox  = proxmox
#     zerotier = zerotier
#     remote   = remote.proxmox
#   }
#   id                     = 112
#   name                   = "samba"
#   compartment            = "glacier"
#   instance_template      = "ubuntu-focal-server-cloudinit"
#   instance_cpus          = 2
#   instance_memory        = 4096
#   instance_disk          = "11468M"
#   network_ip             = "192.168.1.8/24"
#   network_gateway        = "192.168.1.1"
#   ssh_secret_key         = file("../.ssh/automation")
#   ssh_authorized_keys    = var.authorized_keys
#   zerotier_network_id    = var.zerotier_network_id_development
#   zerotier_ip_assignment = "10.147.19.45"
#   ceph_admin_keyring     = var.ceph_admin_keyring
# }
