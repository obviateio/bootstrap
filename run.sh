echo 'Acquire::ForceIPv4 "true";' | sudo tee /etc/apt/apt.conf.d/99force-ipv4

sudo apt-get update
sudo apt-get install -y curl zsh wajig terminator awscli thefuck dconf-editor python-pip
sudo pip install --upgrade pip setuptools
sudo pip install --upgrade mackup
cp ./mackup.cfg ~/.mackup.cfg
touch ~/.zshrc
mackup backup -f

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
sudo add-apt-repository ppa:nathan-renniewaldock/flux
sudo apt-get update
sudo apt-get install -y fluxgui

#Telegram
curl -L https://telegram.org/dl/desktop/linux |sudo tar -xvJ -C /bin/

#Font for zsh
git clone https://github.com/powerline/fonts.git /tmp/fonts
sudo /tmp/fonts/install.sh

#Change Gnome Terminal
./gnome-conf.sh


#OhMyZSH
chsh -s $(which zsh)
mkdir ~/.ssh
chmod 700 ~/.ssh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

