#!/usr/bin/env bash
# ╒══════╗        ╒═══════╗
# │ ╓──┐ ║════════╗  ╓─┐  ║
# │ ╚══╛ ║──┐  ╓──╜  ║ │  ║  RustyTake-Off
# │ ╓─┐ ╓╜  │  ║  │  ║ │  ║  https://github.com/RustyTake-Off
# │ ║ │ ╚╗  │  ║  │  ╚═╛  ║
# └─╜ └──╜  └──╜  └───────╜
# WSL setup script

# Repository      -   "https://github.com/RustyTake-Off/wsl-dotfiles",
# Script file     -   "https://github.com/RustyTake-Off/wsl-dotfiles/blob/main/.local/bin/use-wslup.sh"

# ================================================================================
# Miscellaneous code

if [ ! -d "$HOME/pr" ]; then
  echo "Creating 'personal' directory"
  mkdir "$HOME/pr"
fi

if [ ! -d "$HOME/wk" ]; then
  echo "Creating 'work' directory"
  mkdir "$HOME/wk"
fi

# ================================================================================
# Main code

function get_help() {
  # Help message

  echo "Available commands:"
  echo "  -h  | --help            - Prints help message"
  echo "  -a  | --apt-apps        - Installs apt applications"
  echo "  -b  | --brew            - Installs homebrew"
  echo "  -ba | --brew-apps       - Installs brew applications"
  echo "  -d  | --dotfiles        - Invokes Dotfiles setup script"
}

function get_apt_apps() {
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
    jq \
    fzf \
    ripgrep \
    zoxide

  # Install starship
  if [ ! "$(command -v starship)" ]; then
    echo "Installing Starship ..."
    curl -sS https://starship.rs/install.sh | sudo bash
  fi

  # Install azure cli
  if [ ! "$(command -v az)" ]; then
    echo "Installing AzureCLI ..."
    curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
  fi
}

function get_brew() {
  # Install homebrew if not installed

  if [ ! "$(command -v brew)" ]; then
    echo "Installing Homebrew ..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    echo "Homebrew is already installed!"
  fi
}

function get_brew_apps() {
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
      entr
  fi
}

function set_dotfiles() {
  # Invokes the Dotfiles setup script

  echo "Invoking Dotfiles setup script..."
  if [ -x "$HOME/.config/scripts/set-dotfiles.sh" ]; then
    source "$HOME/.config/scripts/set-dotfiles.sh"
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/RustyTake-Off/wsl-dotfiles/main/.config/scripts/set-dotfiles.sh)"
  fi
  echo "Invoke complete!"
}

# Switch with possible commands
case "$1" in
  -h|--help)
    get_help
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
  *)
    get_help
    ;;
esac
