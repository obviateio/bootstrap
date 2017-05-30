#!/bin/bash

# Force APT to use ipv4, security.ubuntu.com is broken on IPv6
echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4

# Do some basics
mkdir ~/Development
mkdir ~/.aws
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install -y curl zsh wajig terminator thefuck dconf-editor python-pip \
	git software-properties-common indicator-multiload tlp tlp-rdw acpi powertop \
	build-essential htop snapd

sudo pip install --upgrade pip setuptools
sudo tlp start

# Fix middle mouse to NOT paste.
echo "pointer = 1 6 3 4 5 2" | tee ~/.Xmodmap

# Display reset script, used in gnome-conf.sh
ln -s $PWD/display-reset ~/.display-reset

# Git config
cp gitconfig ~/.gitconfig

# AWS Profile Tool
sudo ln -s $PWD/scripts/awsprof /usr/bin/awsprof
ln -s $PWD/completions ~/.oh-my-zsh/completions

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

# Snap based utilities
sudo snap install asciinema --classic
sudo snap install uappexplorer-cli
sudo snap install kubectl --classic
sudo snap install terraform-snap

#VirtualBox & Minikube
echo 'deb http://download.virtualbox.org/virtualbox/debian xenial contrib' | sudo tee /etc/apt/sources.list.d/vbox.list
wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
sudo apt-get update
sudo apt-get install -y virtualbox-5.1 virtualbox-dkms
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.16.0/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/

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
