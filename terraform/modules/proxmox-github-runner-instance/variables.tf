variable "id" {
  type = number
}

variable "name" {
  type    = string
  default = "github-runner"
}

variable "target_node" {
  type = string
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

variable "ssh_authorized_keys" {
  type = string
}

variable "ssh_secret_key" {
  type = string
}

variable "automation_user_password" {
  type = string
}

variable "github_runner_user_password" {
  type = string
}
