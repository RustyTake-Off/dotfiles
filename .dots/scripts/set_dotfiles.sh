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

# Main logic
# Check if Git is installed
if [ ! -x "$(command -v git)" ]; then
  write_colored_message "Git is not installed" "red"
  return 1
fi

# Clone dotfiles
if [ ! -d "$dotfiles_path" ]; then
  write_colored_message "Cloning dotfiles..." "yellow"

  git clone --bare "$repo_url" "$dotfiles_path"
  git --git-dir="$dotfiles_path" --work-tree="$HOME" checkout "$branch_name"
  git --git-dir="$dotfiles_path" --work-tree="$HOME" config status.showUntrackedFiles no
else
  write_colored_message "Dotfiles are set" "yellow"
  write_colored_message "Checking for updates..." "purple"

  git --git-dir="$dotfiles_path" --work-tree="$HOME" reset --hard
  git --git-dir="$dotfiles_path" --work-tree="$HOME" pull origin "$branch_name"
fi
