#cloud-config

users:
  - name: samba
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ${ssh_key}

packages:
  - qemu-guest-agent
  - curl
  - ceph-common
  - ceph-fuse
  - samba
  
runcmd:
  - systemctl start qemu-guest-agent
  # Setup Zerotier
  - curl -o zerotier-install.sh https://raw.githubusercontent.com/jakoberpf/zerotier-scripts/main/zerotier-installer.sh
  - chmod +x zerotier-install.sh
  - ./zerotier-install.sh && rm ./zerotier-install.sh
  - curl -o zerotier-join.sh https://raw.githubusercontent.com/jakoberpf/zerotier-scripts/main/zerotier-join.sh
  - chmod +x zerotier-join.sh
  - ZTNETWORK=${zerotier_network_id} ./zerotier-join.sh && rm ./zerotier-join.sh
  # Mount Ceph Filesystem
  - echo "${ceph_client_admin}" >> admin.key
  - chmod 600 admin.key
  - mkdir -p /mnt/cephfs
  - systemctl enable cephfs.service
  - systemctl start cephfs.service

write_files:
  # Zerotier
  - path: /var/lib/zerotier-one/identity.public
    content: |
      ${zerotier_public_key}

  - path: /var/lib/zerotier-one/identity.secret
    content: |
      ${zerotier_private_key}

  # CephFS
  - path: /etc/systemd/system/cephfs.service
    content: |
      [Unit]
      Description=CephFS mount service

      [Service]
      ExecStart=/bin/mount -t ceph 192.168.1.5:6789:/ /mnt/cephfs -o name=admin,secretfile=/admin.key

      [Install]
      WantedBy=multi-user.target

  # Samba
  - path: /etc/samba/smb.conf
    content: |
      [global]
        workgroup = WORKGROUP
        server string = %h server (CephFS, Samba, Ubuntu)
        log file = /var/log/samba/log.%m
        max log size = 1000
        logging = file
        panic action = /usr/share/samba/panic-action %d
        server role = standalone server
        obey pam restrictions = yes
        unix password sync = yes
        passwd program = /usr/bin/passwd %u
        passwd chat = *Enter\snew\s*\spassword:* %n\n *Retype\snew\s*\spassword:* %n\n *password\supdated\ssuccessfully* .
        pam password change = yes
        map to guest = bad user
        usershare allow guests = yes

      [cephfs]
        comment = Glacier CephFS Sambashare
        path = /mnt/cephfs
        read only = no
        browsable = yes

      [jakoberpf]
        comment = Glacier CephFS | JakobErpf
        path = /mnt/cephfs/users/jakob
        valid users = jakoberpf
        read only = no
        writable = yes
        browsable = yes

      [jakoberpf_timemachine]
        comment = Glacier CephFS | JakobErpf | TimeMachine
        path = /mnt/cephfs/users/jakob/TimeMachine
        browseable = yes
        write list = jakoberpf
        create mask = 0600
        directory mask = 0700
        spotlight = no
        vfs objects = catia fruit streams_xattr
        fruit:aapl = yes
        fruit:time machine = yes
        fruit:time machine max size = 1050G
        durable handles = yes
        kernel oplocks = no
        kernel share modes = no
        posix locking = no
        # NOTE: Changing these will require a new initial backup cycle if you already have an existing timemachine share.
        case sensitive = true
        default case = lower
        preserve case = no
        short preserve case = no

      [fabianerpf]
        comment = Glacier CephFS | FabianErpf
        path = /mnt/cephfs/users/fabian
        valid users = fabianerpf
        read only = no
        writable = yes
        browsable = yes

      [tobiaserpf]
        comment = Glacier CephFS | FabianErpf
        path = /mnt/cephfs/users/tobias
        valid users = tobiaserpf
        read only = no
        writable = yes
        browsable = yes