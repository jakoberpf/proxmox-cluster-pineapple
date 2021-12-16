variable "id" {
  type    = number
  default = 100
}

variable "name" {
  type    = string
  default = "oracle"
}

variable "compartment" {
  type    = string
  default = "oracle"
}

variable "instance_template" {
  type    = string
  default = "ubuntu-focal-server-cloudinit"
}

variable "instance_memory" {
  type    = number
  default = 8000
}

variable "instance_cpus" {
  type    = string
  default = 2
}

variable "network_ip" {
  type    = string
}

variable "network_gateway" {
  type    = string
}

variable "ssh_authorized_keys" {
  type    = string
}

variable "ssh_secret_key" {
  type    = string
}

variable "zerotier_network_id" {
  type    = string
}

variable "zerotier_ip_assignment" {
  type    = string
}

variable "ceph_admin_keyring" {
  type    = string
}
