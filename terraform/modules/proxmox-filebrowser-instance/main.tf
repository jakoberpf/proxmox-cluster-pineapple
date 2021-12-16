terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.4"
    }
    zerotier = {
      source = "zerotier/zerotier"
      version = "1.2.0"
    }
  }
}

resource "random_string" "deployment_id" {
  length  = 5
  upper   = false
  lower   = true
  number  = true
  special = false
}