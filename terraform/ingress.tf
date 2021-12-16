module "backup_ingress" {
  source  = "jakoberpf/gateway-ingress/erpf"
  version = "0.0.5"

  providers = {
    cloudflare = cloudflare
    remote     = remote.gateway1
  }

  domains = [
    "backup.proxmox.erpf.de"
  ]
  host = "10.147.19.79"
  port = 8006

  cloudflare_email   = var.cloudflare_email
  cloudflare_zone_id = var.cloudflare_zone_id
  cloudflare_token   = var.cloudflare_token
}
