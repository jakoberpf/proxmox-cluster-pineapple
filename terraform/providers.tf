terraform {
  required_version = ">= 1.0.0"
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.8.0"
    }
    proxmox = {
      source = "telmate/proxmox"
    }
    remote = {
      source  = "tenstad/remote"
      version = "0.0.23"
    }
    zerotier = {
      source = "zerotier/zerotier"
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
  alias = "proxmox"
  conn {
    user        = "root"
    private_key = file("../.ssh/automation")
    host        = "10.147.19.79"
  }
}

provider "remote" {
  alias = "gateway"
  conn {
    user        = "ubuntu"
    private_key = file("../.ssh/automation")
    host        = "primary.gateway.dns.erpf.de"
    sudo        = true
  }
}

provider "zerotier" {
  zerotier_central_token = var.zerotier_central_token
}
