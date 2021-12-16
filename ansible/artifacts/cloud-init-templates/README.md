# create templates

## ubuntu server

```bash
./create_ubuntu_server_template.sh ubuntu-focal-server-cloudinit https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img 9001 local-lvm
./create_ubuntu_server_template.sh ubuntu-hirsute-server-cloudinit https://cloud-images.ubuntu.com/hirsute/current/hirsute-server-cloudimg-amd64.img 9002 local-lvm
./create_ubuntu_server_template.sh ubuntu-impish-server-cloudinit https://cloud-images.ubuntu.com/impish/current/impish-server-cloudimg-amd64.img 9003 local-lvm
```

## ubuntu desktop

```bash
./create_ubuntu_desktop_template.sh ubuntu-focal-desktop-cloudinit https://releases.ubuntu.com/20.04/ubuntu-20.04.3-desktop-amd64.iso 9011 local-lvm
./create_ubuntu_desktop_template.sh ubuntu-hirsute-desktop-cloudinit https://releases.ubuntu.com/21.04/ubuntu-21.04-desktop-amd64.iso 9012 local-lvm
./create_ubuntu_desktop_template.sh ubuntu-impish-desktop-cloudinit https://releases.ubuntu.com/21.10/ubuntu-21.10-desktop-amd64.iso 9013 local-lvm
```
