terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    proxmox = {
      source = "telmate/proxmox"
    }
    remote = {
      source  = "tenstad/remote"
    }
    zerotier = {
      source = "zerotier/zerotier"
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
