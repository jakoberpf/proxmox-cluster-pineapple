terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
    zerotier = {
      source  = "zerotier/zerotier"
      version = "~> 1.4.2"
    }
    remote = {
      source = "tenstad/remote"
    }
  }
}

resource "random_string" "deployment_id" {
  length  = 5
  upper   = false
  lower   = true
  numeric = true
  special = false
}

resource "random_password" "root_user_password" {
  length = 30
}

resource "random_password" "github_runner_user_password" {
  length = 30
}
