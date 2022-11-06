resource "random_id" "argo_secret" {
  byte_length = 35
}

resource "cloudflare_argo_tunnel" "auto_tunnel" {
  account_id = var.cloudflare_account_id
  name       = "minio_argo_test"
  secret     = random_id.argo_secret.b64_std
}

resource "cloudflare_record" "minio" {
  zone_id = var.cloudflare_zone_id
  name    = "glinio"
  value   = "${cloudflare_argo_tunnel.auto_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "console" {
  zone_id = var.cloudflare_zone_id
  name    = "glonsole"
  value   = "${cloudflare_argo_tunnel.auto_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "vault" {
  zone_id = var.cloudflare_zone_id
  name    = "glault"
  value   = "${cloudflare_argo_tunnel.auto_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}
