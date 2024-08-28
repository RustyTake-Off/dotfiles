#!/usr/bin/env bash
# WSL setup script

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.1.14

# Configuration variables
declare DOTFILES_SCRIPT_PATH="$HOME/.dots/scripts/set_dotfiles.sh"
declare HOME_DIRS="pr wk"

# ANSI escape sequences for different colors
declare -A COLORS=(
  ["red"]="\033[31m"
  ["green"]="\033[32m"
  ["yellow"]="\033[33m"
  ["blue"]="\033[34m"
  ["purple"]="\033[35m"
  ["reset"]="\033[0m"
)

create_dirs() {
  # Create directories
  for dir in $HOME_DIRS; do
    if [ ! -d "$HOME/$dir" ]; then
      echo -e "Creating ${COLORS[yellow]}'$dir'${COLORS[reset]} directory"
      mkdir "$HOME/$dir"
    fi
  done

  # Copy gitconfigs if on WSL2
  if [ "$(uname -r | grep -q 'WSL2')" ]; then
    win_user="$(command powershell.exe '$env:USERNAME' | tr --delete '\r')"
    win_home_path="/mnt/c/Users/${win_user}"

    for dir in $HOME_DIRS; do
      if [ ! -f "$HOME/$dir/$dir.gitconfig" ] && [ -f "$win_home_path/$dir/$dir.gitconfig" ]; then
        echo -e "Copying ${COLORS[yellow]}'$dir.gitconfig'${COLORS[reset]}"
        cp "$win_home_path/$dir/$dir.gitconfig" "$HOME/$dir"
      else
        echo -e "File ${COLORS[red]}'$dir.gitconfig'${COLORS[reset]} in '$win_home_path/$dir' does not exist"
      fi
    done
  fi
}

# Function definitions
write_colored_message() {
  # Color message

  local message="$1"
  local color="$2"
  echo -e "${COLORS[$color]}$message${COLORS[reset]}"
}

get_help() {
  # Help message

  write_colored_message "Available commands:" "yellow"
  echo -e "${COLORS[yellow]}  -h  |  --help      ${COLORS[reset]} - Prints help message"
  echo -e "${COLORS[yellow]}  -a  |  --apt-apps  ${COLORS[reset]} - Install apt applications"
  echo -e "${COLORS[yellow]}  -b  |  --brew      ${COLORS[reset]} - Install homebrew"
  echo -e "${COLORS[yellow]}  -ba |  --brew-apps ${COLORS[reset]} - Install brew applications"
  echo -e "${COLORS[yellow]}  -d  |  --dotfiles  ${COLORS[reset]} - Invokes dotfiles setup script"
}

get_apt_apps() {
  # Install some prerequisite and utility apps

  write_colored_message "Updating and upgrading apt packages..." "yellow"
  sudo apt update && sudo apt upgrade -y

  write_colored_message "Installing prerequisite and utility apps..." "yellow"
  sudo apt install -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    gnupg \
    gpg \
    make \
    net-tools \
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

    az config set core.collect_telemetry=false
  fi

  # Install azure developer cli
  if [ ! -x "$(command -v azd)" ]; then
    write_colored_message "Installing Azure Developer CLI..." "yellow"
    curl -fsSL https://aka.ms/install-azd.sh | bash
  fi
}

get_brew() {
  # Install homebrew if not installed

  if [ ! -x "$(command -v brew)" ]; then
    write_colored_message "Installing Homebrew..." "yellow"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Check if Homebrew is installed and set up the environment
    if [ -x "$(command -v /home/linuxbrew/.linuxbrew/bin/brew)" ]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      command brew completions link

      write_colored_message "Homebrew installed and configured" "green"
    fi
  else
    write_colored_message "Homebrew already installed" "green"
  fi
}

get_brew_apps() {
  # Install homebrew apps

  # Check and install homebrew
  get_brew

  if [ -x "$(command -v brew)" ]; then
    write_colored_message "Installing Homebrew apps..." "yellow"
    brew install \
      ansible \
      entr \
      fzf \
      gh \
      git \
      goenv \
      helm \
      jq \
      k9s \
      kubecm \
      kubectx \
      kubent \
      kubernetes-cli \
      nvm \
      pipx \
      pyenv \
      ripgrep \
      ruff \
      rye \
      tfenv \
      tlrc \
      trash-cli \
      yq \
      zoxide
  fi
}

set_dotfiles() {
  # Invokes dotfiles setup script

  write_colored_message "Invoking dotfiles setup script..." "yellow"

  if [ -x "$DOTFILES_SCRIPT_PATH" ]; then
    source "$DOTFILES_SCRIPT_PATH"
  else
    curl -fsS https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/wslfiles/.dots/scripts/set_dotfiles.sh | bash
  fi

  write_colored_message "Invocation complete" "green"
}

# Main logic
if [ $# -eq 0 ]; then
  get_help
else
  case "$1" in
    -h|--help)
      get_help
      ;;
    -c|--cr-dirs)
      create_dirs
      ;;
    -a|--apt-apps)
      get_apt_apps
      ;;
    -b|--brew)
      get_brew
      ;;
    -ba|--brew-apps)
      get_brew_apps
      ;;
    -d|--dotfiles)
      set_dotfiles
      ;;
    -all|--all)
      create_dirs
      get_apt_apps
      get_brew
      get_brew_apps
      source "$HOME/.bashrc"
      ;;
    *)
	    write_colored_message "Invalid command: $1\n" "red"
      get_help
      ;;
  esac
fi
