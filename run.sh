#!/bin/bash

# Force APT to use ipv4, security.ubuntu.com is broken on IPv6
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4

# Do some basics
mkdir ~/Development
mkdir ~/.aws
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install -y curl zsh wajig terminator thefuck dconf-editor python-pip \
	git software-properties-common indicator-multiload tlp tlp-rdw acpi powertop

sudo pip install --upgrade pip setuptools
sudo tlp start

# Git config
cp gitconfig ~/.gitconfig

# AWS CLI
curl -fsSL -o /usr/share/awscli/aws_zsh_completer.sh https://raw.githubusercontent.com/aws/aws-cli/develop/bin/aws_zsh_completer.sh && chmod a+x /usr/share/awscli/aws_zsh_completer.sh
sudo pip install --upgrade awscli

#Chrome
curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb
sudo dpkg -i /tmp/chrome.deb

#Enpass
echo "deb http://repo.sinew.in/ stable main" | sudo tee /etc/apt/sources.list.d/enpass.list
wget -O - https://dl.sinew.in/keys/enpass-linux.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y enpass

#Atom
curl -L https://atom.io/download/deb -o /tmp/atom.deb
sudo dpkg -i /tmp/atom.deb

#Flux
sudo add-apt-repository -y ppa:nathan-renniewaldock/flux
sudo apt-get update
sudo apt-get install -y fluxgui

#GoLang
sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
sudo apt-get update
sudo apt-get install -y golang
#gopath="/home/$USER/Development/go"
#mkdir $gopath
#echo "export GOROOT="$gopath >> ~/.zshrc
#echo "export PATH="$PATH":"$gopath"/bin" >> ~/.zshrc

#NodeJS
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install nodejs
sudo npm install -g diff-so-fancy

#Telegram
curl -L https://telegram.org/dl/desktop/linux |sudo tar -xvJ -C /bin/

#Font for zsh
git clone https://github.com/powerline/fonts.git /tmp/fonts
sudo /tmp/fonts/install.sh

#Change Gnome Terminal
./gnome-conf.sh

#Docker
curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker $USERNAME

#Ansible
sudo add-apt-repository -y ppa:ansible/ansible
sudo apt-get -y install ansible

#Directory colors!
# From https://github.com/huyz/dircolors-solarized
curl -Lo ./.dircolors.ansi-dark https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-dark

#OhMyZSH
chsh -s $(which zsh)
echo "### Once oh-my-zsh starts zsh, exit it to complete setup proccess ####"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp zshrc ~/.zshrc


# Mackup (Backup) -- Should be last
sudo pip install --upgrade mackup
cp ./mackup.cfg ~/.mackup.cfg
touch ~/.zshrc
mackup backup -f

echo "### DONE ###"
