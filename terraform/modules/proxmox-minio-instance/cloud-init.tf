data "template_file" "cloud_init" {
  template = file("${path.module}/templates/cloud-init.cloud_config.tpl")

  vars = {
    ssh_key              = var.ssh_authorized_keys

    ceph_client_admin    = var.ceph_admin_keyring

    minio_admin_user     = var.minio_glacier_admin_access_key
    minio_admin_key      = var.minio_glacier_admin_secret_key

    zerotier_network_id  = var.zerotier_network_id
    zerotier_public_key  = zerotier_identity.this.public_key
    zerotier_private_key = zerotier_identity.this.private_key

    cloudflare_account_id = var.cloudflare_account_id
    argo_tunnel_id = cloudflare_argo_tunnel.auto_tunnel.id
    argo_tunnel_name = cloudflare_argo_tunnel.auto_tunnel.name
    argo_secret = random_id.argo_secret.b64_std
  }
}

resource "remote_file" "cloud_init" {
  path    = "/var/lib/vz/snippets/cloud-init-minio-standalone-${random_string.deployment_id.result}.yml"
  content = data.template_file.cloud_init.rendered
}
