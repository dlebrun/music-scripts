#!/bin/sh
set -e

# Create group "belighted" and set it as default
sudo addgroup --gid 1001 belighted
sudo adduser dle belighted
sudo usermod -g belighted dle
sudo delgroup dle

# Install extra softwares
sudo add-apt-repository ppa:kubuntu-ppa/backports
sudo add-apt-repository ppa:serge-rider/dbeaver-ce
sudo apt update
sudo apt full-upgrade
sudo apt install build-essential git curl awscli flac kubuntu-restricted-addons kubuntu-restricted-extras network-manager-openvpn software-properties-common dbeaver-ce qgit htop apt-transport-https ca-certificates gnupg-agent software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable test"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io

sudo adduser dle docker

sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo curl -L "https://raw.githubusercontent.com/docker/compose/1.25.0/contrib/completion/bash/docker-compose" -o /etc/bash_completion.d/docker-compose

base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  sudo mv /tmp/docker-machine /usr/local/bin/docker-machine &&
  chmod +x /usr/local/bin/docker-machine

base=https://raw.githubusercontent.com/docker/machine/v0.16.0
for i in docker-machine-prompt.bash docker-machine-wrapper.bash docker-machine.bash
do
  sudo wget "$base/contrib/completion/bash/${i}" -P /etc/bash_completion.d
done

sudo snap install rubymine --classic
sudo snap install slack --classic
sudo snap install bitwarden
sudo snap install google-cloud-sdk --classic
sudo snap install kubectl --classic

echo 'fs.inotify.max_user_watches = 524288' | sudo tee -a /etc/sysctl.d/idea.conf > /dev/null
sudo sysctl -p --system
