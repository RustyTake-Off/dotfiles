#!/usr/bin/env bash
# WSL setup script

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.1.0

# ANSI escape sequences for different colors
red='\e[31m'
green='\e[32m'
yellow='\e[33m'
blue='\e[34m'
purple='\e[35m'
resetColor='\e[0m'

if [ ! -d "$HOME/pr" ]; then
  echo "Creating '${yellow}personal${resetColor}' directory"
  mkdir "$HOME/pr"
fi

if [ ! -d "$HOME/wk" ]; then
  echo "Creating '${yellow}work${resetColor}' directory"
  mkdir "$HOME/wk"
fi

function get-help() {
  # Help message

  echo "Available ${yellow}commands${resetColor}:"
  echo "${yellow}  -h  |  --help      ${resetColor} - Prints help message"
  echo "${yellow}  -a  |  --apt-apps  ${resetColor} - Install apt applications"
  echo "${yellow}  -b  |  --brew      ${resetColor} - Install homebrew"
  echo "${yellow}  -ba |  --brew-apps ${resetColor} - Install brew applications"
  echo "${yellow}  -d  |  --dotfiles  ${resetColor} - Invokes dotfiles setup script"
}

function get-apt-apps() {
  # Install some prerequisite and utility apps

  sudo apt update && sudo apt upgrade -y

  sudo apt install -y \
    apt-transport-https \
    build-essential \
    software-properties-common \
    ca-certificates \
    gnupg \
    gpg \
    wget \
    python3-venv \
    python3-pip \
    python3-tk \
    tree \
    trash-cli \
    unzip \
    jq \
    ripgrep \
    zoxide

  # Install starship
  if [ ! "$(command -v starship)" ]; then
    echo "Installing ${yellow}Starship${resetColor}..."
    curl -sS https://starship.rs/install.sh | sudo bash
  fi

  # Install azure cli
  if [ ! "$(command -v az)" ]; then
    echo "Installing ${yellow}AzureCLI${resetColor}..."
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
  fi
}

function get-brew() {
  # Install homebrew if not installed

  if [ ! "$(command -v brew)" ]; then
    echo "Installing ${yellow}Homebrew${resetColor}..."
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | sudo bash
  else
    echo "Homebrew already ${green}installed${resetColor}"
  fi
}

function get-brew-apps() {
  # Check if homebrew is installed, install if not and install brew apps

  get-brew

  if [ ! "$(command -v brew)" ]; then
    brew install \
      ansible \
      azcopy \
      kubectl \
      helm \
      k9s \
      nvm \
      tfenv \
      terragrunt \
      tlrc \
      entr \
      fzf
  fi
}

function set-dotfiles() {
  # Invokes the dotfiles setup script

  echo "Invoking ${yellow}dotfiles${resetColor} setup script..."

  if [ -x "$HOME/.dots/scripts/set-dotfiles.sh" ]; then
    source "$HOME/.dots/scripts/set-dotfiles.sh"
  else
    curl -fsS https://raw.githubusercontent.com/RustyTake-Off/wsl-dotfiles/main/.dots/scripts/set-dotfiles.sh | sudo bash
  fi

  echo "Invocation ${green}complete${resetColor}"
}

case "$1" in
  -h|--help)
    get-help
    ;;
  -a|--apt-apps)
    get-apt-apps
    ;;
  -b|--brew)
    get-brew
    ;;
  -ba|--brew-apps)
    get-brew-apps
    ;;
  -d|--dotfiles)
    set-dotfiles
    ;;
  *)
    get-help
    ;;
esac
