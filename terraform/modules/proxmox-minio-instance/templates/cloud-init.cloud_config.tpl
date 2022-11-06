#cloud-config

# create the docker group
groups:
  - docker
  # - minio: [minio]

# Add default auto created user to docker group
system_info:
  default_user:
    groups: [docker]

users:
  - default
  - name: minio
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
     - ${ssh_key}

packages:
  - curl
  - gnupg-agent
  - apt-transport-https
  - software-properties-common
  - ca-certificates
  - qemu-guest-agent
  - ceph-common
  - ceph-fuse

runcmd:
  - systemctl start qemu-guest-agent
  # Hosts
  - echo "127.0.0.1  glacier.erpf.de console.glacier.erpf.de vault.glacier.erpf.de" >> /etc/hosts
  # Setup Zerotier
  - curl -o zerotier-install.sh https://raw.githubusercontent.com/jakoberpf/zerotier-scripts/main/zerotier-installer.sh
  - chmod +x zerotier-install.sh
  - ./zerotier-install.sh
  - curl -o zerotier-join.sh https://raw.githubusercontent.com/jakoberpf/zerotier-scripts/main/zerotier-join.sh
  - chmod +x zerotier-join.sh
  - ZTNETWORK=${zerotier_network_id} ./zerotier-join.sh && rm ./zerotier-join.sh
  # Setup Argo Tunnel
  - wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
  - dpkg -i cloudflared-linux-amd64.deb
  - rm cloudflared-linux-amd64.deb
  - cloudflared service install
  # Setup Docker
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  - add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  - apt-get update -y
  - apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose
  - systemctl start docker
  - systemctl enable docker
  # Mount Ceph Filesystem
  - echo "${ceph_client_admin}" >> /admin.key
  - chmod 600 /admin.key
  - mkdir -p /mnt/cephfs/minio-glacier
  - chown minio:minio /mnt/cephfs/minio-glacier
  - systemctl enable cephfs.service
  - systemctl start cephfs.service
  # Start Minio Stack
  - docker-compose -f /minio/docker-compose.yaml up -d

write_files:
  # Zerotier
  - path: /var/lib/zerotier-one/identity.public
    content: |
      ${zerotier_public_key}

  - path: /var/lib/zerotier-one/identity.secret
    content: |
      ${zerotier_private_key}

  - path: /etc/cloudflared/cert.json
    content: |
      {
          "AccountTag"   : "${cloudflare_account_id}",
          "TunnelID"     : "${argo_tunnel_id}",
          "TunnelName"   : "${argo_tunnel_name}",
          "TunnelSecret" : "${argo_secret}"
      }

  - path: /etc/cloudflared/cert.json
    content: |
      tunnel: ${argo_tunnel_id}
      credentials-file: /etc/cloudflared/cert.json
      logfile: /var/log/cloudflared.log
      loglevel: info

      ingress:
        - hostname: glinio.erpf.de
          service: http://localhost:9000
        - hostname: glonsole.erpf.de
          service: http://localhost:9001
        - hostname: glault.erpf.de
          service: http://localhost:9001
        - hostname: "*"
          service: hello-world

  # CephFS
  - path: /etc/systemd/system/cephfs.service
    content: |
      [Unit]
      Description=CephFS mount service

      [Service]
      ExecStart=/bin/mount -t ceph 192.168.1.5:6789:/minio/glacier-0 /mnt/cephfs/minio-glacier -o name=admin,secretfile=/admin.key

      [Install]
      WantedBy=multi-user.target

  # Minio
  - path: /minio/docker-compose.yaml
    content: |
      version: '3'

      services:
        vault:
          image: vault
          container_name: vault
          restart: always
          entrypoint: vault server -config=/vault/config/vault.json  
          cap_add:
            - IPC_LOCK
          ports:
            - 8200:8200
          volumes:
            - /mnt/cephfs/vault-glacier/logs:/vault/logs
            - /mnt/cephfs/vault-glacier/file:/vault/file
            - /mnt/cephfs/vault-glacier/config:/vault/config

        minio:
          image: minio/minio
          container_name: minio
          restart: always
          command: server /data --console-address ":9001"
          ports:
            - 9000:9000
            - 9001:9001
          volumes:
            - /mnt/cephfs/minio-glacier:/data
          environment:
            - MINIO_BROWSER_REDIRECT_URL=https://console.glacier.erpf.de
            - MINIO_ROOT_USER=${minio_admin_user}
            - MINIO_ROOT_PASSWORD=${minio_admin_key}
