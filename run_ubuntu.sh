#!/bin/bash
BLUE='\033[0;34m'; RED='\033[0;31m'; NC='\033[0m'

if [ ! $P ]; then
    echo "Don't invoke this file directly. Use run.sh"
    exit
fi

if [ $SRV ]; then
    echo "Running Ubuntu Server Install"
else
    echo "Running Ubuntu Desktop Install"
fi

# Force APT to use ipv4, security.ubuntu.com is broken on IPv6
# echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4

# Do some basics
sudo apt-get update
#sudo apt-get dist-upgrade -y
sudo apt-get install -y curl zsh wajig thefuck dconf-editor unzip \
    git software-properties-common build-essential htop snapd pv tmux \
    python3 python3-pip lolcat zsh-syntax-highlighting mlocate

if [ $SRV ]; then
    sudo apt-get install -y zfsutils-linux smartmontools nfs-common update-motd figlet
    sudo rm /etc/update-motd.d/50-motd-news
    sudo rm /etc/update-motd.d/10-help-text
    sudo rm /etc/cron.d/popularity-contest
    sudo sed -i "s/ENABLED=1/ENABLED=0/" /etc/default/motd-news
#    sudo rm /etc/update-motd.d/10-help-text /etc/update-motd.d/90-updates-available
    sudo cp ./motd/11-funhost /etc/update-motd.d/11-funhost
#    sudo cp ./motd/12-sysinfo /etc/update-motd.d/12-sysinfo
    sudo update-motd
else
    sudo apt-get install -y terminator indicator-multiload tlp tlp-rdw acpi powertop
fi

#sudo pip install --upgrade pip setuptools
#sudo pip3 install --upgrade pip setuptools
sudo python3 -m pip install --upgrade pip setuptools

# Git config
cp gitconfig ~/.gitconfig

# AWS CLI
#curl -fsSL -o /usr/share/awscli/aws_zsh_completer.sh https://raw.githubusercontent.com/aws/aws-cli/develop/bin/aws_zsh_completer.sh && chmod a+x /usr/share/awscli/aws_zsh_completer.sh
#sudo pip install --upgrade awscli

if [ ! $SRV]; then
    sudo tlp start

    # Fix middle mouse to NOT paste.
    echo "pointer = 1 6 3 4 5 2" | tee ~/.Xmodmap

    # Display reset script, used in gnome-conf.sh
    ln -s $PWD/display-reset ~/.display-reset

    #Chrome
    curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb
    sudo dpkg -i /tmp/chrome.deb

    #Flux
    #sudo add-apt-repository -y ppa:nathan-renniewaldock/flux
    #sudo apt-get update
    #sudo apt-get install -y fluxgui

    #Telegram
    curl -L https://telegram.org/dl/desktop/linux |sudo tar -xvJ -C /bin/

    #Font for zsh
    git clone https://github.com/powerline/fonts.git /tmp/fonts
    sudo /tmp/fonts/install.sh

    #Change Gnome Terminal
    ./gnome-conf.sh

    #VirtualBox
    echo 'deb http://download.virtualbox.org/virtualbox/debian xenial contrib' | sudo tee /etc/apt/sources.list.d/vbox.list
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install -y virtualbox-5.2 virtualbox-dkms
fi

#GoLang
#sudo add-apt-repository -y ppa:ubuntu-lxc/lxd-stable
#sudo apt-get update
#sudo apt-get install -y golang

##gopath="/home/$USER/Development/go"
##mkdir $gopath
##echo "export GOROOT="$gopath >> ~/.zshrc
##echo "export PATH="$PATH":"$gopath"/bin" >> ~/.zshrc

#NodeJS
#curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
#sudo apt-get install nodejs
#sudo npm install -g diff-so-fancy


#Docker & Minikube
#curl -sSL https://get.docker.com/ | sh
#sudo usermod -aG docker $USERNAME
#curl -Lo minikube https://storage.googleapis.com/minikube/releases/v0.25.2/minikube-linux-amd64 && chmod +x minikube && sudo mv minikube /usr/local/bin/
#curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/


#Directory colors!
# From https://github.com/seebi/dircolors-solarized
curl -Lo ~/.dircolors.256dark https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.256dark

# Snap based utilities
#sudo snap install asciinema --classic
#sudo snap install uappexplorer-cli
#sudo snap install kubectl --classic # Not up to date
#sudo snap install terraform-snap

#OhMyZSH
#chsh -s $(which zsh)
printf "${BLUE}####### ${RED}Once oh-my-zsh starts zsh, exit it to complete setup proccess ${BLUE}######${NC}\n"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm ~/.zshrc
ln -s $PWD/dotfiles/zshrc ~/.zshrc
ln -s $PWD/dotfiles/nanorc ~/.nanorc

# AWS Profile Tool
#sudo ln -s $PWD/scripts/awsprof /usr/bin/awsprof
#ln -s $PWD/completions ~/.oh-my-zsh/completions


#if [ $srv == 0 ]; then
# # Mackup (Backup) -- Should be last
# sudo pip install --upgrade mackup
# cp ./mackup.cfg ~/.mackup.cfg
# touch ~/.zshrc
# mackup backup -f
#fi

ZSH_CUSTOM=~/.oh-my-zsh/custom/
cp agnostersgn.zsh-theme $ZSH_CUSTOM/agnostersgn.zsh-theme
git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
#updatedb &

### Misc Fixes
wget https://github.com/Peltoche/lsd/releases/download/0.18.0/lsd_0.18.0_amd64.deb -O /tmp/lsd.deb
sudo dpkg -i /tmp/lsd.deb
rm /tmp/lsd.deb

git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
#echo 'eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)' >> /home/jdavis/.zshrc
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
brew install derailed/k9s/k9s asciinema kubectl ansible helm

printf "${BLUE}####### ${RED}Install Done! ${BLUE}######${NC}\n\n"
