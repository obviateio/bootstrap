DEFAULT_USER="jdavis"

if [ `uname` = 'Darwin' ]; then
  #OSX Specific
  export ZSH=/Users/jdavis/.oh-my-zsh
  source /usr/local/share/zsh/site-functions/_aws
  source /usr/local/share/zsh/site-functions/_m
elif [ `uname` = 'Linux' ]; then
  #Linux Specific
  export ZSH=/home/jdavis/.oh-my-zsh
  source /usr/share/zsh/vendor-completions/_awscli
fi

keys=`ssh-add -l`
if [ -d ~/.ssh/ ]; then
  for i in ~/.ssh/id_*.pub; do
    if ! echo "$keys" | grep -q "${i%.pub}" ; then
      ssh-add "${i%.pub}"
    fi
  fi
done

ZSH_THEME="agnoster"
export UPDATE_ZSH_DAYS=7
HIST_STAMPS="yyyy-mm-dd"
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
source $ZSH/oh-my-zsh.sh
export PATH=$PATH:/usr/local/opt/go/libexec/bin
export GOPATH=~/Development/gosrc
plugins=(git aws command-not-found node npm sudo golang python zsh-completions)

TF_ALIAS=fuck alias fuck='eval $(thefuck $(fc -ln -1 | tail -n 1)); fc -R'
fpath=(/usr/local/share/zsh-completions $fpath)

#autoload -U compinit && compinit #for zsh-completions -- doing funny things

alias pwgen="pwgen -Cs 20 1"

unsetopt share_history


# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# ZSH_CUSTOM=/path/to/new-custom-folder
# export MANPATH="/usr/local/man:$MANPATH"
# export LANG=en_US.UTF-8
# export ARCHFLAGS="-arch x86_64"
# export SSH_KEY_PATH="~/.ssh/dsa_id"
# For a full list of active aliases, run `alias`.
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
