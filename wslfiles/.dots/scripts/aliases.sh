#!/usr/bin/env bash
# Various aliases

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.1.3

# Common aliases
alias cd......="cd ../../../../../.."
alias cd.....="cd ../../../../.."
alias cd....="cd ../../../.."
alias cd...="cd ../../.."
alias cd..="cd ../.."
alias cd.="cd .."
alias hm="cd ~"
alias hpr="cd ~/pr"
alias hwk="cd ~/wk"
alias trash="cd ~/trash"

alias h="history"
alias cls="clear"

alias ls="ls --color=always --group-directories-first"
alias la="ls -a --color=always --group-directories-first"
alias ll="ls -al --color=always --group-directories-first"

alias df="df -h"
alias free="free -m"
alias psa="ps auxf"
alias pscpu="ps auxf | sort -nr -k 3"
alias psmem="ps auxf | sort -nr -k 4"

# Files manipulation
alias cp="cp -vi"
alias mkdir="mkdir -vp"
alias mv="mv -vi"
alias rm="rm -vI"

alias less="less -R"
alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

# Get ip addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias locip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '([0-9]*\\.){3}[0-9]*' | grep -v '127.0.0.1'"

# Alias for opening windows explorer
if uname -r | grep -q "WSL2"; then
  alias open="explorer.exe"
fi

# Manage dotfiles in $HOME directory
alias dot='git --git-dir="$HOME/.dots" --work-tree=$HOME'
alias setdots=". \$HOME/.dots/scripts/set-dotfiles.sh"
alias wslup=". \$HOME/.dots/scripts/wslup.sh"

alias apti="sudo apt install"
alias sup="sudo apt update"
alias supup="sudo apt update && sudo apt upgrade -y"
alias brup="brew upgrade"
alias lcoms="compgen -b  # Print built-in commands"

# Python aliases
alias py="python3"
alias pysetup="python3 -m venv .venv --upgrade-deps && source .venv/bin/activate"
alias pyup="source .venv/bin/activate"
alias pydw="deactivate"
alias pipi="pip3 install"
alias pipu="pip3 install --upgrade"
alias pipuall="pip3 freeze --local | cut -d = -f 1  | xargs -n1 pip3 install --upgrade  # Upgrades all packages"
alias pysetreq="pip3 freeze > requirements.txt"
alias pygetreq="pip3 install -r requirements.txt"

alias k="kubectl"
alias hl="helm"
alias tf="terraform"
