#!/usr/bin/env bash
# Various aliases

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.1.8

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
alias mkdir="mkdir -vp"
alias cp="cp -vi"
alias mv="mv -vi"
alias rm="rm -vI"

# trash-cli - https://github.com/andreafrancia/trash-cli
alias trm="trash-put"
alias tre="trash-empty"
alias trl="trash-list"
alias trr="trash-restore"
alias trc="trash-rm"

alias less="less -R --use-color"
alias diff="diff --color=auto --side-by-side"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

# Get ip addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias locip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '([0-9]*\\.){3}[0-9]*' | grep -v '127.0.0.1'"

# Aliases for WSL
if uname -r | grep -q "WSL2"; then
  alias open="command explorer.exe"
  alias pwsh="command pwsh.exe"
  alias powershell="command powersell.exe"
fi

# Manage dotfiles in $HOME directory
alias dot="git --git-dir=\$HOME/.dotfiles --work-tree=\$HOME"
alias setdots=". \$HOME/.dots/scripts/set_dotfiles.sh"
alias wslup=". \$HOME/.dots/scripts/wslup.sh"

alias apti="sudo apt install"
alias sup="sudo apt update"
alias supup="sudo apt update && sudo apt upgrade -y"
alias brup="brew upgrade"
alias lcoms="compgen -b  # Print built-in commands"

# Python aliases
alias py="python"
alias py3="python3"
alias pyv="pyenv versions"
alias pyi="pyenv install -v"
alias pyg="pyenv global"
alias pyl="pyenv local"
alias pysetup="py -m venv .venv --upgrade-deps && source .venv/bin/activate"
alias py3setup="py3 -m venv .venv --upgrade-deps && source .venv/bin/activate"
alias pyup="source .venv/bin/activate"
alias pydw="deactivate"
alias pipi="pip install"
alias pipu="pip install --upgrade"
alias pipuall="pip freeze --local | cut -d = -f 1 | xargs -n1 pip3 install --upgrade  # Upgrades all packages"
alias pipsetreq="pip freeze --require-virtualenv -l >"
alias pipgetreq="pip install --require-virtualenv -rU"

alias k="kubectl"
alias hl="helm"
alias tf="terraform"
