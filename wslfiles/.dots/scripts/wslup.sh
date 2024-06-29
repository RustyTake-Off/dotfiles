#!/usr/bin/env bash
# WSL setup script

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.1.9

# Configuration variables
dotfilesScriptPath="$HOME/.dots/scripts/set_dotfiles.sh"

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
  echo "Creating ${colors["yellow"]}'personal'${colors["reset"]} directory"
  mkdir "$HOME/pr"
fi

if [ ! -d "$HOME/wk" ]; then
  echo "Creating ${colors["yellow"]}'work'${colors["reset"]} directory"
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
  echo -e "${colors["yellow"]}  -h  |  --help      ${colors["reset"]} - Prints help message"
  echo -e "${colors["yellow"]}  -a  |  --apt-apps  ${colors["reset"]} - Install apt applications"
  echo -e "${colors["yellow"]}  -b  |  --brew      ${colors["reset"]} - Install homebrew"
  echo -e "${colors["yellow"]}  -ba |  --brew-apps ${colors["reset"]} - Install brew applications"
  echo -e "${colors["yellow"]}  -d  |  --dotfiles  ${colors["reset"]} - Invokes dotfiles setup script"
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
    python3-venv \
    software-properties-common \
    tree \
    unzip \
    wget

  # Install starship
  if [ ! -x "$(command -v starship)" ]; then
    write_colored_message "Installing Starship..." "yellow"
    curl -sS https://starship.rs/install.sh | sh
  fi

  # Install azure cli
  if [ ! -x "$(command -v az)" ]; then
    write_colored_message "Installing AzureCLI..." "yellow"
    curl -L https://aka.ms/InstallAzureCli | bash

    command az config set core.collect_telemetry=false
  fi

  # Install azure developer cli
  if [ ! -x "$(command -v azd)" ]; then
    write_colored_message "Installing Azure Developer CLI..." "yellow"
    curl -fsSL https://aka.ms/install-azd.sh | bash
  fi
}

function get_brew() {
  # Install homebrew if not installed

  if [ ! -x "$(command -v brew)" ]; then
    write_colored_message "Installing Homebrew..." "yellow"
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash

    [ -x "$(command -v /home/linuxbrew/.linuxbrew/bin/brew)" ] && \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    command brew completions link
  else
    write_colored_message "Homebrew already installed" "green"
  fi
}

function get_brew_apps() {
  # Install homebrew apps

  get_brew

  if [ -x "$(command -v brew)" ]; then
    brew install \
      ansible \
      azcopy \
      entr \
      fzf \
      helm \
      jq \
      k9s \
      kubernetes-cli \
      kubectx \
      nvm \
      pipx \
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
    curl -fsS https://raw.githubusercontent.com/RustyTake-Off/dotfiles/wslfiles/.dots/scripts/set_dotfiles.sh | bash
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
