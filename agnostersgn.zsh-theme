# Based originally from: https://github.com/zakaziko99/agnosterzak-ohmyzsh-theme
# Updated by Jon "ShakataGaNai" Davis 2018
#
#
# Icon Codes: https://nerdfonts.com/#cheat-sheet
# Custom Color: https://jonasjacek.github.io/colors/
# Solarized Definition: http://ethanschoonover.com/solarized


CURRENT_BG='NONE'

# Special Powerline characters

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  SEGMENT_SEPARATOR=$'\ue0b0' # 
  RSEGMENT_SEPARATOR=$'\ue0b2'
}

prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  if [[ -n "$SSH_CLIENT" ]]; then
    prompt_segment magenta white "%{$fg_bold[white]%}%(!.%{%F{white}%}.)$USER@%m%{$fg_no_bold[white]%}"
  else
    # Username formatting
    prompt_segment green white "%{$fg_bold[white]%}%(!.%{%F{white}%}.)$USER%{$fg_no_bold[white]%}"
  fi
}

# Battery Level
prompt_battery() {
  if [ $(battery_pct 2> /dev/null) ];then
   # http://fontawesome.io/cheatsheet/
   SYM="\uf011 "
   CHG="\uf1e6 "
   BATTF="\uf240 "
   BATTH="\uf242 "
   BATTE="\uf244 "

    b=$(battery_pct)
    if plugged_in ; then
      SYM=$CHG
      prompt_segment blue white
    else
      if [ $b -gt 50 ] ; then
        SYM=$BATTF
        prompt_segment green white
      elif [ $b -gt 20 ] ; then
        SYM=$BATTH
        prompt_segment yellow white
      else
        SYM=$BATTE
        prompt_segment red white
      fi
    fi
    echo -n "%{$fg_bold[white]%}$SYM$b%%%{$fg_no_bold[white]%}"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
#«»±˖˗‑‐‒ ━ ✚‐↔←↑↓→↭⇎⇔⋆━◂▸◄►◆☀★☗☊✔✖❮❯⚑⚙
  local PL_BRANCH_CHAR
  () {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8"
    PL_BRANCH_CHAR=$'\ue0a0'         # 
  }
  local ref dirty mode repo_path clean has_upstream
  local modified untracked added deleted tagged stashed
  local ready_commit git_status bgclr fgclr
  local commits_diff commits_ahead commits_behind has_diverged to_push to_pull

  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    git_status=$(git status --porcelain 2> /dev/null)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"
    if [[ -n $dirty ]]; then
      clean=''
      bgclr='yellow'
      fgclr='magenta'
    else
      clean=' ✔'
      bgclr='green'
      fgclr='white'
    fi

    local upstream=$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2> /dev/null)
    if [[ -n "${upstream}" && "${upstream}" != "@{upstream}" ]]; then has_upstream=true; fi

    local current_commit_hash=$(git rev-parse HEAD 2> /dev/null)

    local number_of_untracked_files=$(\grep -c "^??" <<< "${git_status}")
    # if [[ $number_of_untracked_files -gt 0 ]]; then untracked=" $number_of_untracked_files◆"; fi
    if [[ $number_of_untracked_files -gt 0 ]]; then untracked=" $number_of_untracked_files☀"; fi

    local number_added=$(\grep -c "^A" <<< "${git_status}")
    if [[ $number_added -gt 0 ]]; then added=" $number_added✚"; fi

    local number_modified=$(\grep -c "^.M" <<< "${git_status}")
    if [[ $number_modified -gt 0 ]]; then
      modified=" $number_modified●"
      bgclr='red'
      fgclr='white'
    fi

    local number_added_modified=$(\grep -c "^M" <<< "${git_status}")
    local number_added_renamed=$(\grep -c "^R" <<< "${git_status}")
    if [[ $number_modified -gt 0 && $number_added_modified -gt 0 ]]; then
      modified="$modified$((number_added_modified+number_added_renamed))±"
    elif [[ $number_added_modified -gt 0 ]]; then
      modified=" ●$((number_added_modified+number_added_renamed))±"
    fi

    local number_deleted=$(\grep -c "^.D" <<< "${git_status}")
    if [[ $number_deleted -gt 0 ]]; then
      deleted=" $number_deleted‒"
      bgclr='red'
      fgclr='white'
    fi

    local number_added_deleted=$(\grep -c "^D" <<< "${git_status}")
    if [[ $number_deleted -gt 0 && $number_added_deleted -gt 0 ]]; then
      deleted="$deleted$number_added_deleted±"
    elif [[ $number_added_deleted -gt 0 ]]; then
      deleted=" ‒$number_added_deleted±"
    fi

    local tag_at_current_commit=$(git describe --exact-match --tags $current_commit_hash 2> /dev/null)
    if [[ -n $tag_at_current_commit ]]; then tagged=" ☗$tag_at_current_commit "; fi

    local number_of_stashes="$(git stash list -n1 2> /dev/null | wc -l)"
    if [[ $number_of_stashes -gt 0 ]]; then
      stashed=" $number_of_stashes⚙"
      bgclr='magenta'
      fgclr='white'
    fi

    if [[ $number_added -gt 0 || $number_added_modified -gt 0 || $number_added_deleted -gt 0 ]]; then ready_commit=' ⚑'; fi

    local upstream_prompt=''
    if [[ $has_upstream == true ]]; then
      commits_diff="$(git log --pretty=oneline --topo-order --left-right ${current_commit_hash}...${upstream} 2> /dev/null)"
      commits_ahead=$(\grep -c "^<" <<< "$commits_diff")
      commits_behind=$(\grep -c "^>" <<< "$commits_diff")
      upstream_prompt="$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2> /dev/null)"
      upstream_prompt=$(sed -e 's/\/.*$/ ☊ /g' <<< "$upstream_prompt")
    fi

    has_diverged=false
    if [[ $commits_ahead -gt 0 && $commits_behind -gt 0 ]]; then has_diverged=true; fi
    if [[ $has_diverged == false && $commits_ahead -gt 0 ]]; then
      if [[ $bgclr == 'red' || $bgclr == 'magenta' ]] then
        to_push=" %{$fg_bold[white]%}↑$commits_ahead%{$fg_bold[$fgclr]%}"
      else
        to_push=" %{$fg_bold[black]%}↑$commits_ahead%{$fg_bold[$fgclr]%}"
      fi
    fi
    if [[ $has_diverged == false && $commits_behind -gt 0 ]]; then to_pull=" %{$fg_bold[magenta]%}↓$commits_behind%{$fg_bold[$fgclr]%}"; fi

    if [[ -e "${repo_path}/BISECT_LOG" ]]; then
      mode=" <B>"
    elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
      mode=" >M<"
    elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
      mode=" >R>"
    fi

    prompt_segment $bgclr $fgclr

    echo -n "%{$fg_bold[$fgclr]%}${ref/refs\/heads\//$PL_BRANCH_CHAR $upstream_prompt}${mode}$to_push$to_pull$clean$tagged$stashed$untracked$modified$deleted$added$ready_commit%{$fg_no_bold[$fgclr]%}"
  fi
}

# Dir: current working directory
prompt_dir() {
  SYM="\uf114 "
  prompt_segment cyan white "%{$fg_bold[white]%}$SYM %~%{$fg_no_bold[white]%}"
}

prompt_time() {
  # date/time uses http://strftime.net/ formatting
  prompt_segment blue white "%{$fg_bold[white]%}\uf073 %D{%FT%R%Z}%{$fg_no_bold[white]%}"
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

# Kube additions from https://gist.github.com/nballotta/cab3e389e5fb541222677e5b4ec90c7f
prompt_kubecontext() {
  if type "kubectl" > /dev/null; then
   if [ $(kubectl config get-contexts|wc -l) -gt 1 ]; then
    if [[ $(kubectl config current-context) == *"testing"* ]]; then
        prompt_segment green black "(`kubectl config current-context`)"
    elif [[ $(kubectl config current-context) == *"tectonic"* ]]; then
        prompt_segment yellow black "(`kubectl config current-context`)"
    elif [[ $(kubectl config current-context) == *"staging"* ]]; then
        prompt_segment yellow black "(`kubectl config current-context`)"
    elif [[ $(kubectl config current-context) == *"production"* ]]; then
        prompt_segment red yellow "(`kubectl config current-context`)"
    fi
   fi
  fi
}

prompt_awsprofile() {
  if [ "$(ls -A ~/.aws)" ]; then
   if [[ $AWS_DEFAULT_PROFILE == *"default"* ]] || [[ -z "$AWS_DEFAULT_PROFILE" ]]; then
        prompt_segment green black "AWS@off"
   else
        prompt_segment red black "AWS@`echo $AWS_DEFAULT_PROFILE`"
   fi
  fi
}

prompt_music(){
  if [ "$OS" = "MACOS" ]; then
   P=`jq -j '.playing' ~/Library/Application\ Support/Google\ Play\ Music\ Desktop\ Player/json_store/playback.json`
   if [[ $P == "true" ]]; then
         A=`jq -j '.song.title' ~/Library/Application\ Support/Google\ Play\ Music\ Desktop\ Player/json_store/playback.json`
         B=`jq -j '.song.artist' ~/Library/Application\ Support/Google\ Play\ Music\ Desktop\ Player/json_store/playback.json`
         prompt_segment 92 black
         echo -n "\uf04b $B - $A"
   fi
  fi
}

prompt_internet(){
  if [ "$OS" = "MACOS" ]; then
   AP="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
   #source on quality levels - http://www.wireless-nets.com/resources/tutorials/define_SNR_values.html
   #source on signal levels  - http://www.speedguide.net/faq/how-to-read-rssisignal-and-snrnoise-ratings-440
   local signal=$($AP -I | grep agrCtlRSSI | awk '{print $2}' | sed 's/-//g')
   local noise=$($AP -I | grep agrCtlNoise | awk '{print $2}' | sed 's/-//g')
   local SNR=$(bc <<<"scale=2; $signal / $noise")

   local net=$(curl -D- -o /dev/null -s http://www.google.com | grep HTTP/1.1 | awk '{print $2}')
   local color='yellow'
   local symbol="\uf197"

   # Excellent Signal (5 bars)
   if [[ ! -z "${signal// }" ]] && [[ $SNR -gt .40 ]] ;
     then color='blue' ; symbol="\uf1eb" ;
   fi

   # Good Signal (3-4 bars)
   if [[ ! -z "${signal// }" ]] && [[ ! $SNR -gt .40 ]] && [[ $SNR -gt .25 ]] ;
     then color='green' ; symbol="\uf1eb" ;
   fi

   # Low Signal (2 bars)
   if [[ ! -z "${signal// }" ]] && [[ ! $SNR -gt .25 ]] && [[ $SNR -gt .15 ]] ;
     then color='yellow' ; symbol="\uf1eb" ;
   fi

   # Very Low Signal (1 bar)
   if [[ ! -z "${signal// }" ]] && [[ ! $SNR -gt .15 ]] && [[ $SNR -gt .10 ]] ;
     then color='%red' ; symbol="\uf1eb" ;
   fi

   # No Signal - No Internet
   if [[ ! -z "${signal// }" ]] && [[ ! $SNR -gt .10 ]] ;
     then color='red' ; symbol="\uf011";
   fi
   if [[ -z "${signal// }" ]] && [[ "$net" -ne 200 ]] ;
     then color='red' ; symbol="\uf011" ;
   fi

   # Ethernet Connection (no wifi, hardline)
   if [[ -z "${signal// }" ]] && [[ "$net" -eq 200 ]] ;
     then color='blue' ; symbol="\uf197" ;
   fi
   prompt_segment $color white
   echo -n " $symbol " # \f1eb is wifi bars
  fi
}

## Main prompt
build_prompt() {
  RETVAL=$?
  echo -n "\n"
  prompt_status
  prompt_battery
  prompt_internet
  prompt_time
  prompt_dir
  prompt_git
  prompt_awsprofile
  prompt_kubecontext
  prompt_music
  prompt_end
  CURRENT_BG='NONE'
  echo -n "\n"
  prompt_context
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '
