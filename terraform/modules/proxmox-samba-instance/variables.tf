variable "id" {
  type = number
}

variable "name" {
  type    = string
  default = "samba"
}

variable "compartment" {
  type    = string
  default = "default"
}

variable "instance_template" {
  type    = string
  default = "ubuntu-focal-server-cloudinit"
}

variable "instance_memory" {
  type    = number
  default = 4096
}

variable "instance_cpus" {
  type    = string
  default = 2
}

variable "instance_disk" {
  type    = string
  default = "8192M"
}

variable "network_ip" {
  type = string
}

variable "network_gateway" {
  type = string
}

variable "ssh_authorized_keys" {
  type = string
}

variable "ssh_secret_key" {
  type = string
}

variable "zerotier_network_id" {
  type = string
}

variable "zerotier_ip_assignment" {
  type = string
}

variable "ceph_admin_keyring" {
  type = string
}
