#!/usr/bin/env bash
# WSL setup script

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off

# Configuration variables
dotfiles_script_path="$HOME/.dots/scripts/set_dotfiles.sh"
declare home_dirs=("pr" "wk")

# ANSI escape sequences for different colors
declare -A colors=(
  ["red"]="\033[31m"
  ["green"]="\033[32m"
  ["yellow"]="\033[33m"
  ["blue"]="\033[34m"
  ["purple"]="\033[35m"
  ["reset"]="\033[0m"
)

create_dirs() {
  # Create directories
  for dir in "${home_dirs[@]}"; do
    if [[ ! -d "$HOME/$dir" ]]; then
      echo -e "Creating ${colors[yellow]}'$dir'${colors[reset]} directory"
      mkdir "$HOME/$dir"
    fi
  done

  # Copy gitconfigs if on WSL2
  if [[ "$(grep -w 'WSL2' <(uname -r))" ]]; then
    win_user="$(command powershell.exe '$env:USERNAME')"
    win_home_path="/mnt/c/Users/${win_user//$'\r'/}"

    for dir in "${home_dirs[@]}"; do
      if [[ ! -f "$HOME/$dir/$dir.gitconfig" ]] && [[ -f "$win_home_path/$dir/$dir.gitconfig" ]]; then
        echo -e "Copying ${colors[yellow]}'$dir.gitconfig'${colors[reset]}"
        cp "$win_home_path/$dir/$dir.gitconfig" "$HOME/$dir"
      else
        echo -e "File ${colors[red]}'$dir.gitconfig'${colors[reset]} in '$win_home_path/$dir' does not exist"
      fi
    done
  fi
}

# Function definitions
write_colored_message() {
  # Color message

  local message="$1"
  local color="$2"
  echo -e "${colors[$color]}$message${colors[reset]}"
}

get_help() {
  # Help message

  write_colored_message "Available commands:" "yellow"
  echo -e "${colors[yellow]}  -h  |  --help      ${colors[reset]} - Prints help message"
  echo -e "${colors[yellow]}  -a  |  --apt-apps  ${colors[reset]} - Install apt applications"
  echo -e "${colors[yellow]}  -b  |  --brew      ${colors[reset]} - Install homebrew"
  echo -e "${colors[yellow]}  -ba |  --brew-apps ${colors[reset]} - Install brew applications"
  echo -e "${colors[yellow]}  -d  |  --dotfiles  ${colors[reset]} - Invokes dotfiles setup script"
  echo -e "${colors[yellow]}  -all  |  --all  ${colors[reset]} - Creates dirs and installs apt, brew apps"
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
  if [[ ! -x "$(command -v starship)" ]]; then
    write_colored_message "Installing Starship..." "yellow"
    curl -sS https://starship.rs/install.sh | sh
  fi

  # Install azure cli
  if [[ ! -x "$(command -v az)" ]]; then
    write_colored_message "Installing AzureCLI..." "yellow"
    curl -L https://aka.ms/InstallAzureCli | bash

    az config set core.collect_telemetry=false
  fi

  # Install azure developer cli
  if [[ ! -x "$(command -v azd)" ]]; then
    write_colored_message "Installing Azure Developer CLI..." "yellow"
    curl -fsSL https://aka.ms/install-azd.sh | bash
  fi
}

get_brew() {
  # Install homebrew if not installed

  if [[ ! -x "$(command -v brew)" ]]; then
    write_colored_message "Installing Homebrew..." "yellow"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Check if Homebrew is installed and set up the environment
    if [[ -x "$(command -v /home/linuxbrew/.linuxbrew/bin/brew)" ]]; then
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

  if [[ -x "$(command -v brew)" ]]; then
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
      shellcheck \
      shfmt \
      tenv \
      tlrc \
      trash-cli \
      yq \
      zoxide
  fi
}

set_dotfiles() {
  # Invokes dotfiles setup script

  write_colored_message "Invoking dotfiles setup script..." "yellow"

  if [[ -x "$DOTFILES_SCRIPT_PATH" ]]; then
    source "$DOTFILES_SCRIPT_PATH"
  else
    curl -fsS https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/wslfiles/.dots/scripts/set_dotfiles.sh | bash
  fi

  write_colored_message "Invocation complete" "green"
}

# Main logic
if [[ $# -eq 0 ]]; then
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
