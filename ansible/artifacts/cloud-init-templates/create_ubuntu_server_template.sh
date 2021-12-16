#!/usr/bin/env bash

template_name=$1
template_image=$2
template_id=$3
template_storage=$4
# Navigate to the ISO directory for Proxmox
cd /var/lib/vz/template/iso

# Source the image
wget $template_image -O $template_name.img

apt-get install libguestfs-tools -y
virt-customize -a $template_name.img --install qemu-guest-agent

# Create the instance
qm create $template_id -name $template_name -memory 1024 -net0 virtio,bridge=vmbr0 -cores 1 -sockets 1

# Import the Ubuntu disk image to Proxmox storage
qm importdisk $template_id $template_name.img $template_storage

# Attach the disk to the virtual machine
qm set $template_id -scsihw virtio-scsi-pci -virtio0 $template_storage:vm-$template_id-disk-0

# Add a serial output
qm set $template_id -serial0 socket

# Set the bootdisk to the imported Ubuntu disk
qm set $template_id -boot c -bootdisk virtio0

# Enable the Qemu agent
qm set $template_id -agent 1

# Allow hotplugging of network, USB and disks
qm set $template_id -hotplug disk,network,usb

# Add a single vCPU (for now)
qm set $template_id -vcpus 1

# Add a video output
qm set $template_id -vga qxl

# Set a second hard drive, using the inbuilt cloudinit drive
qm set $template_id -ide2 $template_storage:cloudinit

# Resize the primary boot disk (otherwise it will be around 2G by default)
# This step adds another 8G of disk space, but change this as you need to
qm resize $template_id virtio0 +8G

# Convert the VM to the template
qm template $template_id

rm $template_name.img