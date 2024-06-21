#!/usr/bin/env bash
# Dotfiles setup script

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.1.1

set -euo pipefail

# Configuration variables
repoUrl="https://github.com/RustyTake-Off/dotfiles.git"
dotfilesPath="$HOME/.dotfiles"
wslfilesPath="wslfiles"
dotfilesScriptPath="$HOME/.dots/scripts/set_dotfiles.sh"

# ANSI escape sequences for different colors
declare -A colors=(
  ["red"]="\033[31m"
  ["green"]="\033[32m"
  ["yellow"]="\033[33m"
  ["reset"]="\033[0m"
)

# Function definitions
function write_colored_message {
  # Color message

  local message="$1"
  local color="$2"
  echo -e "${colors[$color]}$message${colors["reset"]}"
}

function check_and_ask_to_install {
  # Check and ask to install

  local package_name="$1"
  if [ -x "$(command -v $package_name)" ]; then
    return 1
  fi

  write_colored_message "$package_name is not installed" "red"

  while true; do
    read -rp "Do you want to install ${colors["yellow"]}$package_name${colors["reset"]} (y/N)? " choice
    choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]' | xargs)

    case "$choice" in
      y) return 0 ;;
      n) write_colored_message "Stopping script. Bye, bye" "red"; exit 1 ;;
      *) write_colored_message "Invalid input, please enter 'y' or 'n'" "red" ;;
    esac
  done
}

# Main logic
# Check and install git
if check_and_ask_to_install "git"; then
  write_colored_message "Installing Git..." "yellow"
  sudo apt update && sudo apt install -y git
  write_colored_message "Installed Git" "green"
else
  write_colored_message "Git is installed" "green"
fi

# Clone dotfiles
if [ ! -d "$dotfilesPath" ]; then
  write_colored_message "Cloning dotfiles..." "yellow"

  git clone --bare "$repoUrl" "$dotfilesPath"
  git --git-dir="$dotfilesPath" --work-tree="$HOME" checkout "$wslfilesPath"
  git --git-dir="$dotfilesPath" --work-tree="$HOME" config status.showUntrackedFiles no
else
  write_colored_message "Directory '.dotfiles' already exists in '$HOME'" "red"
  exit 1
fi
