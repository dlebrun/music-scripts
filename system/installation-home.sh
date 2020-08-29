#!/bin/sh

set -e

# Create group "sda" and set it as default
sudo addgroup --gid 1001 sda
sudo adduser dom sda
sudo adduser dom dialout
sudo usermod -g sda dom
sudo delgroup dom

# Mount backup disk
sudo mkdir /mnt/backups
sudo sh -c "echo \"# Manually created backup mount on /mnt/backups\" >> /etc/fstab"
sudo sh -c "echo \"UUID=32eeea79-f205-48dd-ab0f-8e21c05ef741 /mnt/backups    ext4    defaults        0       2\" >> /etc/fstab"

# Install extra softwares
sudo add-apt-repository ppa:musicbrainz-developers/stable
sudo add-apt-repository ppa:team-xbmc/ppa
sudo add-apt-repository ppa:subsurface/subsurface
sudo pkcon refresh
sudo pkcon update
sudo apt install git flac kubuntu-restricted-extras network-manager-openvpn ffmpeg software-properties-common libdvd-pkg kodi picard subsurface muon kate k3b digikam ktorrent
sudo dpkg-reconfigure libdvd-pkg
sudo snap install bitwarden
sudo snap install authy
