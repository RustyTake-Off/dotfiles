#!/usr/bin/env bash
# Various aliases

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.1.16

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
alias rm="rm -I"

# trash-cli - https://github.com/andreafrancia/trash-cli
[ -x "$(command -v trash)" ] && {
  alias trp="trash-put"
  alias tre="trash-empty"
  alias trl="trash-list"
  alias trr="trash-restore"
  alias trm="trash-rm"
}

# Get date/time
alias nowd="date '+%d/%m/%Y'"
alias nowdw="date '+%A %B %d %Y'"
alias nowt="date '+%H:%M:%S'"

# Get ip addresses
alias pubip="dig +short myip.opendns.com @resolver1.opendns.com"
alias locip="sudo ifconfig | grep -Eo 'inet (addr:)?([0-9]*\\.){3}[0-9]*' | grep -Eo '([0-9]*\\.){3}[0-9]*' | grep -v '127.0.0.1'"

alias less="less -R --use-color"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias fgrep="fgrep --color=auto"

alias j="jobs -l"
alias df="df -h"
alias free="free -m"
alias psa="ps auxf"
alias pscpu="ps auxf | sort -nr -k 3"
alias psmem="ps auxf | sort -nr -k 4"

alias apti="sudo apt install"
alias sup="sudo apt update"
alias sug="sudo apt upgrade -y"
alias supug="sudo apt update && sudo apt upgrade -y"

[ -x "$(command -v brew)" ] && {
  alias br="brew"
  complete -F _brew br  # Add completion
  alias brin="brew install"
  alias brun="brew uninstall"
  alias brif="brew info"
  alias brli="brew list"
  alias brup="brew upgrade"
}

alias acoms="compgen -a | nl"  # Print all aliases
alias bcoms="compgen -b | nl"  # Print built-in shell commands
__f__ccoms() {
  [ -z "$1" ] \
  && apropos -s 1 "" | sort | nl \
  || apropos -s 1 "" | grep "$@" | sort | nl
}
alias ccoms="__f__ccoms"  # Print all runnable commands
alias fcoms="compgen -A function | nl"  # Print all functions that you could run
alias kcoms="compgen -k | nl"  # Print shell reserved keywords

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

[ -x "$(command -v pyenv)" ] && {
  alias pyv="pyenv versions"
  alias pyi="pyenv install -v"
  alias pyg="pyenv global"
  alias pyl="pyenv local"
}

[ -x "$(command -v rye)" ] && {
  alias ryi="rye init"
  alias ryp="rye pin"
  alias rys="rye sync"
  alias rya="rye add"
  alias ryad="rye add --dev"
  alias ryrm="rye remove"
  alias ryl="rye list"
  alias ryr="rye run"
}

alias pysetup="py -m venv .venv --upgrade-deps && source .venv/bin/activate"
alias py3setup="py3 -m venv .venv --upgrade-deps && source .venv/bin/activate"

alias pyup="source .venv/bin/activate"
alias pydw="deactivate"

alias pipi="pip install"
alias pipu="pip install --upgrade"
alias pipuall="pip freeze --local | cut -d = -f 1 | xargs -n1 pip3 install --upgrade"
alias pipsetreq="pip freeze --require-virtualenv -l >"
alias pipgetreq="pip install --require-virtualenv --upgrade -r"

# Docker aliases
[ -x "$(command -v docker)" ] && {
  alias d="docker"
  type _completion_loader &> /dev/null \
  && _completion_loader docker && complete -F __start_docker docker
  # Add completion
  alias dps="docker ps"
  alias dcmi="docker images"
  alias dcv="docker volume"
  alias dcn="docker network"
  alias dcs="docker stats"

  alias dcru="docker run -it"
  alias dcrum="docker run -it --rm"
  alias dcex="docker exec -it"
  alias dcsta="docker start"
  alias dcsto="docker stop"
  alias dcrm="docker rm"
  __f__dcrma() {
    docker rm "$(docker ps -aq --filter 'status=exited')"
  }
  alias dcrma="__f__dcrma"
  alias dcl="docker logs"
  alias dckl="docker kill"
  __f__dci() {
    [ -z "$2" ] \
    && docker inspect "$1" | jq -r ".[0]" \
    || docker inspect "$1" | jq -r ".[0].$2"
  }
  alias dci="__f__dci"

  alias dcb="docker build -t"
  alias dcpl="docker pull"
  alias dcpu="docker push"
  alias dcrmi="docker rmi"
  alias dct="docker tag"
  alias dch="docker history"

  alias dcom="docker compose"
  alias dcomu="docker compose up -d"
  alias dcomub="docker compose up -d --build"
  alias dcomd="docker compose down"
  alias dcomsta="docker compose start"
  alias dcomdto="docker compose stop"
  alias dcomr="docker compose restart"

  alias dcoms="docker compose stats"
  alias dcoml="docker compose logs"
  alias dcomb="docker compose build"
  alias dcomp="docker compose pull"

  alias dcicl="docker image prune"
  alias dcvcl="docker volume prune"
  alias dcncl="docker network prune"
}

alias k="kubectl"
alias kcx="kubectx"
alias hl="helm"
alias tf="terraform"
