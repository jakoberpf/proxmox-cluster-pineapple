/* resource "local_file" "ssh_config" {
  content = templatefile("${path.module}/templates/config.tpl",
    {
      node-ip = [
        # module.minio_glacier.zt_ip,
        # module.filebrowser_glacier.zt_ip,
        # module.samba_glacier.zt_ip
      ]
      node-id = [
        # "minio-glacier",
        # "filebrowser-glacier",
        # "samba-glacier"
      ],
      node-user = [
        # "minio",
        # "filebrowser",
        # "samba"
      ],
      node-key = "${abspath(path.root)}/../.ssh/automation"
    }
  )
  filename = "${path.root}/../.ssh/config"
} */
