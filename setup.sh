#!/usr/bin/env bash
# Dotfiles setup script

# GitHub      - https://github.com/RustyTake-Off
# GitHub Repo - https://github.com/RustyTake-Off/dotfiles
# Author      - RustyTake-Off

# Configuration variables
repo_url="https://github.com/RustyTake-Off/dotfiles.git"
dotfiles_path="$HOME/.dotfiles"
branch_name="wslfiles"

# ANSI escape sequences for different colors
declare -A colors=(
  ["red"]="\033[31m"
  ["green"]="\033[32m"
  ["yellow"]="\033[33m"
  ["blue"]="\033[34m"
  ["purple"]="\033[35m"
  ["reset"]="\033[0m"
)

# Function definitions
write_colored_message() {
  # Color message

  local message="$1"
  local color="$2"
  echo -e "${colors[$color]}${message}${colors[reset]}"
}

check_and_ask_to_install() {
  # Check and ask to install

  local package_name="$1"
  if [[ -x "$(command -v $package_name)" ]]; then
    return 1
  fi

  write_colored_message "$package_name is not installed" "red"

  while true; do
    read -rp "$(write_colored_message "Do you want to install $package_name (y/n)? " "yellow")" choice

    case "${choice,,}" in
      y|yes) return 0 ;;
      n|no) write_colored_message "Stopping script. Bye, bye" "red"; return 1 ;;
      *) write_colored_message "Invalid input, please enter 'y' or 'n'" "red" ;;
    esac
  done
}

# Main logic
# Check and install git
if check_and_ask_to_install "git"; then
  write_colored_message "Installing Git..." "yellow"

  sudo apt-get update && sudo apt-get install -y git

  write_colored_message "Installed Git" "green"
else
  write_colored_message "Git is installed" "green"
fi

# Clone dotfiles
if [[ ! -d "$dotfiles_path" ]]; then
  write_colored_message "Cloning dotfiles..." "yellow"

  git clone --bare "$repo_url" "$dotfiles_path"
  git --git-dir="$dotfiles_path" --work-tree="$HOME" checkout --force "$branch_name"
  git --git-dir="$dotfiles_path" --work-tree="$HOME" config status.showUntrackedFiles no

  [[ -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"
else
  write_colored_message "Dotfiles are set" "yellow"
  write_colored_message "Checking for updates..." "purple"

  git --git-dir="$dotfiles_path" --work-tree="$HOME" reset --hard
  git --git-dir="$dotfiles_path" --work-tree="$HOME" pull origin "$branch_name"
fi
