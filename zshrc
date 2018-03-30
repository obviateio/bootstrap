DEFAULT_USER="jdavis"

if [ `uname` = 'Darwin' ]; then
  #OSX Specific
  export OS="MACOS"
  export ZSH=/Users/jdavis/.oh-my-zsh
elif [ `uname` = 'Linux' ]; then
  #Linux Specific
  export OS="LINUX"
  export ZSH=/home/jdavis/.oh-my-zsh
fi

ZSH_CUSTOM=/home/jdavis/.oh-my-zsh/custom
plugins=(git command-not-found sudo python zsh-completions mosh ansible iterm2 zsh-autosuggestions)
#plugins=(node npm go)

if [ "$(ls -A ~/.aws)" ]; then
 plugins=( aws )
fi

if type "kubectl" > /dev/null; then
  if [ $(kubectl config get-contexts|wc -l) -gt 1 ]; then
   plugins=( kubectl )
  fi
fi

if [[ -d "/usr/share/zsh/vendor-completions" ]]; then
  fpath=(/usr/share/zsh/vendor-completions $fpath)
fi

keys=`ssh-add -l`
if [ -d ~/.ssh/ ]; then
  for i in ~/.ssh/id_*.pub; do
    if ! echo "$keys" | grep -q "${i%.pub}" ; then
      ssh-add "${i%.pub}"
    fi
  done
fi

ZSH_THEME="agnostersgn"
export UPDATE_ZSH_DAYS=7
export HIST_STAMPS="yyyy-mm-dd"
source $ZSH/oh-my-zsh.sh
export GOPATH=~/Development/gosrc
export MICRO_TRUECOLOR=1

if [ "$OS" = "MACOS" ]; then
  plugin=(battery)
  eval `gdircolors ~/.dircolors.256dark`
  export PATH="/usr/local/sbin:/usr/local/opt/go/libexec/bin:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/snap/bin:$PATH:/usr/local/opt/go/libexec/bin"
  export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
else
  eval `dircolors ~/.dircolors.256dark`
  export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/snap/bin:/usr/games" 
fi
export PATH=$PATH:/usr/local/opt/go/libexec/bin

TF_ALIAS=fuck alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'
alias pwgen="pwgen -Cs 20 1"
alias awsprof=". awsprof"

unsetopt share_history

# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# export MANPATH="/usr/local/man:$MANPATH"
# export LANG=en_US.UTF-8
# export ARCHFLAGS="-arch x86_64"
# export SSH_KEY_PATH="~/.ssh/dsa_id"
# For a full list of active aliases, run `alias`.
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"


# brew install zsh-syntax-highlighting
# git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
# curl -L https://iterm2.com/shell_integration/zsh -o ~/.iterm2_shell_integration.zsh
#xtrasrc=(
# $ZSH/oh-my-zsh.sh
# ${HOME}/.iterm2_shell_integration.zsh
# /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# )

#for a in $xtrasrc; do
# test -e $a && source $a
#done;

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'

alias ls="ls --color=always"
alias lols="ls --color=no | lolcat"
