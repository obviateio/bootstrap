echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4

apt-get update
apt-get install curl zsh wajig terminator awscli

#Chrome
curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/chrome.deb
sudo dpkg -i /tmp/chrome.deb

#Enpass
echo "deb http://repo.sinew.in/ stable main" | sudo tee /etc/apt/sources.list.d/enpass.list
wget -O - https://dl.sinew.in/keys/enpass-linux.key | sudo apt-key add -
sudo apt-get update
sudo apt-get install enpass

#Atom
curl https://atom.io/download/deb -o /tmp/atom.deb
sudo dpkg -i /tmp/atom.deb

#Flux
sudo add-apt-repository ppa:nathan-renniewaldock/flux
sudo apt-get update
sudo apt-get install fluxgui

#OhMyZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mkdir ~/.ssh
chmod 700 ~/.ssh

git clone https://github.com/powerline/fonts.git /tmp/fonts
sudo /tmp/fonts/install.sh
