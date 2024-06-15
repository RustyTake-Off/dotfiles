#!/usr/bin/env bash
# WSL setup script

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.1.4

set -euo pipefail

# Configuration variables
dotfilesScriptPath="$HOME/.dots/scripts/set-dotfiles.sh"

# ANSI escape sequences for different colors
declare -A colors=(
  ["red"]="\033[31m"
  ["green"]="\033[32m"
  ["yellow"]="\033[33m"
  ["blue"]="\033[34m"
  ["purple"]="\033[35m"
  ["reset"]="\033[0m"
)

if [ ! -d "$HOME/pr" ]; then
  write_colored_message "Creating 'personal' directory" "yellow"
  mkdir "$HOME/pr"
fi

if [ ! -d "$HOME/wk" ]; then
  write_colored_message "Creating 'work' directory" "yellow"
  mkdir "$HOME/wk"
fi

# Function definitions
function write_colored_message() {
  # Color message

  local message=$1
  local color=$2
  echo -e "${colors[$color]}$message${colors["reset"]}"
}

function get_help() {
  # Help message

  write_colored_message "Available commands:" "yellow"
  echo "${colors["yellow"]}  -h  |  --help      ${colors["reset"]} - Prints help message"
  echo "${colors["yellow"]}  -a  |  --apt-apps  ${colors["reset"]} - Install apt applications"
  echo "${colors["yellow"]}  -b  |  --brew      ${colors["reset"]} - Install homebrew"
  echo "${colors["yellow"]}  -ba |  --brew-apps ${colors["reset"]} - Install brew applications"
  echo "${colors["yellow"]}  -d  |  --dotfiles  ${colors["reset"]} - Invokes dotfiles setup script"
}

function get_apt_apps() {
  # Install some prerequisite and utility apps

  sudo apt update && sudo apt upgrade -y

  sudo apt install -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    gnupg \
    gpg \
    python3-pip \
    python3-tk \
    python3-venv \
    software-properties-common \
    tree \
    unzip \
    wget

  # Install starship
  if [ ! -x "$(command -v starship)" ]; then
    write_colored_message "Installing Starship..." "yellow"
    curl -sS https://starship.rs/install.sh | sudo bash
  fi

  # Install azure cli
  if [ ! -x "$(command -v az)" ]; then
    write_colored_message "Installing AzureCLI..." "yellow"
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
  fi
}

function get_brew() {
  # Install homebrew if not installed

  if [ ! -x "$(command -v brew)" ]; then
    write_colored_message "Installing Homebrew..." "yellow"
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | sudo bash
  else
    write_colored_message "Homebrew already installed" "green"
  fi
}

function get_brew_apps() {
  # Install homebrew apps

  get_brew

  if [ ! -x "$(command -v brew)" ]; then
    brew install \
      ansible \
      azcopy \
      entr \
      fzf \
      helm \
      jq \
      k9s \
      kubectl \
      kubectx \
      nvm \
      pyenv \
      ripgrep \
      terragrunt \
      tfenv \
      tlrc \
      trash-cli \
      yq \
      zoxide
  fi
}

function set_dotfiles() {
  # Invokes dotfiles setup script

  write_colored_message "Invoking dotfiles setup script..." "yellow"

  if [ -x "$dotfilesScriptPath" ]; then
    source "$dotfilesScriptPath"
  else
    curl -fsS https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/wslfiles/.dots/scripts/set-dotfiles.sh | sudo bash
  fi

  write_colored_message "Invocation complete" "green"
}

case "$1" in
  -h|--help)
    get_help ;;
  -a|--apt-apps)
    get_apt_apps ;;
  -b|--brew)
    get_brew ;;
  -ba|--brew-apps)
    get_brew_apps ;;
  -d|--dotfiles)
    set_dotfiles ;;
  *)
    get_help ;;
esac
