terraform {
  required_version = ">= 1.0.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.8.0"
    }
    proxmox = {
      source  = "telmate/proxmox"
      version = "~> 2.9.14"
    }
    remote = {
      source  = "tenstad/remote"
      version = "~> 0.1.2"
    }
    zerotier = {
      source  = "zerotier/zerotier"
      version = "~> 1.4.2"
    }
  }
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

provider "proxmox" {
  pm_api_url  = var.proxmox_terraform_host
  pm_user     = var.proxmox_terraform_user
  pm_password = var.proxmox_terraform_password
}

provider "remote" {
  alias = "compute-1"
  conn {
    user        = "root"
    private_key = file("../.ssh/automation")
    host        = "172.30.119.190"
  }
}

provider "remote" {
  alias = "compute-2"
  conn {
    user        = "root"
    private_key = file("../.ssh/automation")
    host        = "172.30.119.87"
  }
}

provider "remote" {
  alias = "compute-3"
  conn {
    user        = "root"
    private_key = file("../.ssh/automation")
    host        = "172.30.119.79"
  }
}

provider "remote" {
  alias = "glacier"
  conn {
    user        = "root"
    private_key = file("../.ssh/automation")
    host        = "172.30.119.142"
  }
}

provider "zerotier" {
  zerotier_central_token = var.zerotier_central_token
}
