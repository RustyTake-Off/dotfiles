#!/usr/bin/env bash
# Various aliases

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.1.13

# Common aliases
alias cd......="cd ../../../../../.."
alias cd.....="cd ../../../../.."
alias cd....="cd ../../../.."
alias cd...="cd ../../.."
alias cd..="cd ../.."
alias cd.="cd .."
alias hm="cd $HOME"
alias hpr="cd $HOME/pr"
alias hwk="cd $HOME/wk"
alias tmp="cd /tmp"
alias gotr="cd $HOME/.local/share/Trash/files"

alias h="history"
alias hf="fc -s"  # Rerun last command or last command starting with some letters
alias hfl="fc -l"  # Prints recent commands
alias cls="clear"

alias ls="ls --color=always --group-directories-first"
alias la="ls -a --color=always --group-directories-first"
alias ll="ls -al --color=always --group-directories-first"

# Files manipulation
alias mkdir="mkdir -vp"
alias mktmp="mktemp"  # Make temp file in /tmp
alias cp="cp -vi"
alias mv="mv -vi"
alias rm="rm -vI"

# trash-cli - https://github.com/andreafrancia/trash-cli
alias trp="trash-put"
alias tre="trash-empty"
alias trl="trash-list"
alias trr="trash-restore"
alias trm="trash-rm"

# Get ip addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias locip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '([0-9]*\\.){3}[0-9]*' | grep -v '127.0.0.1'"

alias less="less -R --use-color"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

alias df="df -h"
alias free="free -m"
alias psa="ps auxf"
alias pscpu="ps auxf | sort -nr -k 3"
alias psmem="ps auxf | sort -nr -k 4"

alias apti="sudo apt install"
alias sup="sudo apt update"
alias supup="sudo apt update && sudo apt upgrade -y"
alias brup="brew upgrade"

alias acoms="compgen -a | nl"  # Print all aliases
alias bcoms="compgen -b | nl"  # Print built-in shell commands
alias kcoms="compgen -k | nl"  # Print shell reserved keywords
fccoms() {
  [ -z "$1" ] \
  && apropos -s 1 "" | sort | nl \
  || apropos -s 1 "" | grep "$@" | sort | nl
}
alias ccoms="fccoms"  # Print all runnable commands

# Manage dotfiles in $HOME directory
alias dot="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"
alias setdots="source $HOME/.dots/scripts/set_dotfiles.sh"
alias wslup="source $HOME/.dots/scripts/wslup.sh"

# Aliases for WSL
if [ -n "$(uname -r | grep -w "WSL2")" ]; then
  alias open="command explorer.exe"
  alias pwsh="command pwsh.exe"
  alias pwsh5="command powershell.exe"
fi

# Python aliases
alias py="python"
alias py3="python3"

alias pyv="pyenv versions"
alias pyi="pyenv install -v"
alias pyg="pyenv global"
alias pyl="pyenv local"

alias ryi="rye init"
alias ryp="rye pin"
alias rys="rye sync"
alias rya="rye add"
alias ryad="rye add --dev"
alias ryr="rye remove"
alias ryl="rye list"

alias pysetup="py -m venv .venv --upgrade-deps && source .venv/bin/activate"
alias py3setup="py3 -m venv .venv --upgrade-deps && source .venv/bin/activate"

alias pyup="source .venv/bin/activate"
alias pydw="deactivate"

alias pipi="pip install"
alias pipu="pip install --upgrade"
alias pipuall="pip freeze --local | cut -d = -f 1 | xargs -n1 pip3 install --upgrade"
alias pipsetreq="pip freeze --require-virtualenv -l >"
alias pipgetreq="pip install --require-virtualenv --upgrade -r"

alias k="kubectl"
alias kcx="kubectx"
alias hl="helm"
alias tf="terraform"
