#!/bin/bash
# u16 v0.1.0
# OS: ubuntu 16.04

set -e
set -u
set -o pipefail

cd $(dirname ${BASH_SOURCE[0]})

echo "$USER ALL=NOPASSWD: ALL" | (sudo su -c 'EDITOR="tee -a" visudo')

echo "vm.swappiness=20" | sudo tee -a /etc/sysctl.conf

sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:wireguard/wireguard
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install -y \
	linux-headers-generic build-essential checkinstall \
	unzip unrar pv mc tree screen easy-rsa dconf-tools xclip lm-sensors \
	psmisc lshw htop iotop iftop nethogs whois \
	vim vim-gui-common hexer git fossil curl jq \
	feh redshift vlc \
	dnsmasq  wireguard \
	libsqlite3-dev \
	perl perl-modules perl-base \
	python python-dev python-setuptools python-crypto

sudo easy_install -U pip
sudo pip install -U pip setuptools cython ipython virtualenv
sudo pip install -U git+git://github.com/3n0t/authme.git

/usr/lib/apt/apt-helper download-file http://debian.sur5r.net/i3/pool/main/s/sur5r-keyring/sur5r-keyring_2018.01.30_all.deb keyring.deb SHA256:baa43dbbd7232ea2b5444cae238d53bebb9d34601cc000e82f11111b1889078a
sudo dpkg -i ./keyring.deb
rm -f ./keyring.deb
echo "deb http://debian.sur5r.net/i3/ $(grep '^DISTRIB_CODENAME=' /etc/lsb-release | cut -f2 -d=) universe" | sudo tee /etc/apt/sources.list.d/sur5r-i3.list
sudo apt-get update
sudo apt-get install -y i3 i3blocks

gsettings set org.gnome.desktop.background show-desktop-icons false

sudo cp whois.conf /etc/whois.conf
echo "cache-size=10000" | sudo tee /etc/NetworkManager/dnsmasq.d/cache

mkdir -p /home/$USER/.config
mkdir -p /home/$USER/.ssh
mkdir -p /home/$USER/dev
mkdir -p /home/$USER/log
mkdir -p /home/$USER/run
mkdir -p /home/$USER/notes
mkdir -p /home/$USER/.vim
mkdir -p /home/$USER/.vim/.undo
mkdir -p /home/$USER/.vim/.backup
mkdir -p /home/$USER/.vim/.swp
cp vim/.vimrc /home/$USER
cp -r vim/plugin /home/$USER/.vim
cp -r vim/colors /home/$USER/.vim
cp .bashrc /home/$USER
cp .inputrc /home/$USER
cp -r bin /home/$USER/
cp -r wallpapers /home/$USER/Pictures/
cp ssh/config /home/$USER/.ssh/config
cp -r htop /home/$USER/.config
cp -r mc /home/$USER/.config

sudo update-alternatives --set editor /usr/bin/vim.basic

git config --global user.name $USER
git config --global user.email $USER@mail
git config --global credential.helper 'cache --timeout=36000'

mkdir -p /home/$USER/.config/i3
cp i3/config /home/$USER/.config/i3
cp i3/.i3blocks.conf /home/$USER/
sudo cp -r i3/i3blocks /usr/share/

sudo chown -R $USER:$USER /home/$USER

sudo systemctl restart network-manager

echo "_.|.. ^v^ ..|._"

# dconf load /org/gnome/terminal/legacy/profiles:/:id/ < gnome-terminal-profile.dconf

# unstable wifi
# sudo iwconfig wlan0 power off
# /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
# [connection]
# wifi.powersave = 2

# firefox
# browser.tabs.closeWindowWithLastTab false
