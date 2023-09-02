variable "cloudflare_email" {
  type        = string
  description = ""
}

variable "cloudflare_zone_id" {
  type        = string
  description = ""
}

variable "cloudflare_api_key" {
  type        = string
  description = ""
}

variable "cloudflare_token" {
  type        = string
  description = ""
}

variable "cloudflare_account_id" {
  type        = string
  description = ""
}

variable "proxmox_terraform_user" {
  type        = string
  description = ""
}

variable "proxmox_terraform_password" {
  type        = string
  description = ""
}

variable "proxmox_terraform_host" {
  type        = string
  description = ""
}

variable "zerotier_central_token" {
  type        = string
  description = "The zerotier central token"
}
variable "zerotier_network_id_development" {
  type        = string
  description = "The zerotier network id of the development network"
}

variable "ceph_admin_keyring" {
  type        = string
  description = "The ceph.client.admin.keyring"
}

variable "authorized_keys" {
  type        = string
  description = ""
}

variable "minio_glacier_admin_access_key" {
  type        = string
  description = "The access key for the glacier minio admin"
}

variable "minio_glacier_admin_secret_key" {
  type        = string
  description = "The secret key for the glacier minio admin"
}

variable "automation_user_password" {
  type = string
}

variable "github_runner_user_password" {
  type = string
}
