#!/usr/bin/env bash
# ╒══════╗        ╒═══════╗
# │ ╓──┐ ║════════╗  ╓─┐  ║
# │ ╚══╛ ║──┐  ╓──╜  ║ │  ║  RustyTake-Off
# │ ╓─┐ ╓╜  │  ║  │  ║ │  ║  https://github.com/RustyTake-Off
# │ ║ │ ╚╗  │  ║  │  ╚═╛  ║
# └─╜ └──╜  └──╜  └───────╜
# Bash aliases
# File executed from ~/.bashrc

# Movement
alias cd......="cd ../../../../../.."
alias cd.....="cd ../../../../.."
alias cd....="cd ../../../.."
alias cd...="cd ../../.."
alias cd..="cd ../.."
alias cd.="cd .."
alias hm="cd ~"
alias hpr="cd ~/pr"
alias hwk="cd ~/wk"

# Alias for opening windows explorer
if uname -r | grep -q "WSL2"; then
  alias open="explorer.exe"
fi

# To work with dotfiles in $HOME and setup scripts
alias dot='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'
alias setdots=". \$HOME/.config/scripts/set-dotfiles.sh"
alias wslup=". \$HOME/.config/scripts/use-wslup.sh"

# Files manipulation
alias cp="cp -vi"
alias mkdir="mkdir -vp"
alias mv="mv -vi"
alias rm="rm -vI"

alias sup="sudo apt update"
alias supup="sudo apt update && sudo apt upgrade -y"
alias brup="brew upgrade"
alias lcoms="compgen -b"

alias h="history"
alias cls="clear"

alias ls="ls --color=always --group-directories-first"
alias la="ls -a --color=always --group-directories-first"
alias ll="ls -al --color=always --group-directories-first"
alias diff="diff --color=auto"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

alias df="df -h"
alias free="free -m"
alias psa="ps auxf"
alias pscpu="ps auxf | sort -nr -k 3"
alias psmem="ps auxf | sort -nr -k 4"

# Get ip addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias locip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '([0-9]*\\.){3}[0-9]*' | grep -v '127.0.0.1'"

# Python aliases
alias py="python3"
alias pysetup="python3 -m venv .venv && source .venv/bin/activate"
alias pysetreq="pip3 freeze > requirements.txt"
alias pygetreq="pip3 install -r requirements.txt"
alias pyup="source .venv/bin/activate"
alias pydw="deactivate"
alias pipi="pip3 install"
alias pipu="pip3 install --upgrade"
alias pipuall="pip3 freeze --local | cut -d = -f 1  | xargs -n1 pip3 install --upgrade" # for upgrading all packages

# Misc aliases
alias k="kubectl"
alias hl="helm"
alias tf="terraform"
