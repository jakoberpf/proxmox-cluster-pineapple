#!/usr/bin/env bash
echo "Running script with bash version: $BASH_VERSION"
GIT_ROOT=$(git rev-parse --show-toplevel)
cd $GIT_ROOT

mkdir .iso
cd .iso

# Linux
lsblk
dd bs=1M conv=fdatasync if=./proxmox-ve.iso of=/dev/XYZ

# MacOS
hdiutil convert -format UDRW -o proxmox-ve.dmg proxmox-ve.iso
diskutil unmountDisk /dev/disk2
sudo dd if=proxmox-ve.dmg of=/dev/rdisk2 bs=1m
