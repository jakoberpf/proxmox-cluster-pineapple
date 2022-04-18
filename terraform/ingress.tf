module "backup_ingress" {
  source  = "/Users/jakoberpf/Code/jakoberpf/terraform/modules/erpf/caddy-ingress" # "jakoberpf/gateway-ingress/erpf"

  providers = {
    cloudflare = cloudflare
    remote     = remote.gateway
  }

  domains = [
    "backup.proxmox.erpf.de"
  ]
  host = "10.147.19.79"
  port = 8006

  cloudflare_email   = var.cloudflare_email
  cloudflare_zone_id = var.cloudflare_zone_id
  cloudflare_token   = var.cloudflare_token
  cloudflare_record_value = "primary.gateway.dns.erpf.de"
}
