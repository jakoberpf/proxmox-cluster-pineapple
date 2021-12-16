#cloud-config

package_update: true
package_upgrade: true
package_reboot_if_required: true

# create the docker group
groups:
  - docker

# Add default auto created user to docker group
system_info:
  default_user:
    groups: [docker]

users:
  - default
  - name: filebrowser
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ${ssh_key}
 
packages:
  - apt-transport-https
  - ca-certificates
  - curl
  - gnupg-agent
  - software-properties-common
  - qemu-guest-agent
  - ceph-common
  - ceph-fuse

runcmd:
  - systemctl start qemu-guest-agent
  # Setup Zerotier
  - curl -o zerotier-install.sh https://raw.githubusercontent.com/jakoberpf/zerotier-scripts/main/zerotier-installer.sh
  - chmod +x zerotier-install.sh
  - ./zerotier-install.sh && rm ./zerotier-install.sh
  - curl -o zerotier-join.sh https://raw.githubusercontent.com/jakoberpf/zerotier-scripts/main/zerotier-join.sh
  - chmod +x zerotier-join.sh
  - ZTNETWORK=${zerotier_network_id} ./zerotier-join.sh && rm ./zerotier-join.sh
  # Setup docker
  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
  - add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  - apt-get update -y
  - apt-get install -y docker-ce docker-ce-cli containerd.io
  - systemctl start docker
  - systemctl enable docker
  # Setup docker-compose
  - curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  - chmod +x /usr/local/bin/docker-compose
  # Cephfs Mount
  - echo "${ceph_client_admin}" >> admin.key
  - chmod 600 admin.key
  - mkdir -p /mnt/cephfs
  - systemctl enable cephfs.service
  - systemctl start cephfs.service
  # Filebrowser
  - systemctl enable filebrowser.service
  - systemctl start filebrowser.service

write_files:
  - path: /filebrowser/docker-compose.yaml
    content: |
      version: "3"

      services:
        filebrowser:
          image: hurlenko/filebrowser
          user: "$${UID}:$${GID}"
          ports:
            - 80:8080
          volumes:
            - /mnt/cephfs:/data
            - ./config:/config
          restart: always
        # keycloak-gatekeeper:
        #   image: keycloak/keycloak-gatekeeper:7.0.0
        #   labels:
        #   - "traefik.port=3000"
        #   - "traefik.frontend.rule=Host:service1.lab.com"
        #   - "traefik.protocol=http"
        #   restart: always
        #   external_links:
        #     - traefik:auth.lab.com
        #   volumes:
        #     - ./keycloak-gatekeeper.conf:/etc/keycloak-gatekeeper.conf
        #   entrypoint:
        #     - /opt/keycloak-gatekeeper
        #     - --config=/etc/keycloak-gatekeeper.conf

  - path: /etc/keycloak-gatekeeper.conf
    content: |
      discovery-url: https://iam.erpf.de/auth/realms/infrastructure
      client-id: gatekeeper
      client-secret: 
      listen: :3000
      enable-refresh-tokens: false
      redirection-url: http://127.0.0.1:3000
      upstream-url: http://backblaze:80/
      secure-cookie: false
      resources:
      - uri: /*
        methods:
        - GET

  # https://geek-cookbook.funkypenguin.co.nz/ha-docker-swarm/traefik-forward-auth/keycloak/
  # https://stackoverflow.com/questions/58408971/how-can-i-configure-a-containerized-keycloak-gatekeeper-to-act-as-a-reverse-prox

  - path: /etc/systemd/system/filebrowser.service
    content: |
      [Unit]
      Description=Filebrowser Docker Compose Service
      Requires=docker.service
      After=docker.service

      [Service]
      WorkingDirectory=/filebrowser
      ExecStart=/usr/local/bin/docker-compose up
      ExecStop=/usr/local/bin/docker-compose down
      TimeoutStartSec=0
      Restart=on-failure
      StartLimitIntervalSec=60
      StartLimitBurst=3

      [Install]
      WantedBy=multi-user.target

  - path: /etc/systemd/system/cephfs.service
    content: |
      [Unit]
      Description=CephFS mount service

      [Service]
      ExecStart=/bin/mount -t ceph 192.168.1.5:6789:/ /mnt/cephfs -o name=admin,secretfile=/admin.key

      [Install]
      WantedBy=multi-user.target

  - path: /var/lib/zerotier-one/identity.public
    content: |
      ${zerotier_public_key}

  - path: /var/lib/zerotier-one/identity.secret
    content: |
      ${zerotier_private_key}
