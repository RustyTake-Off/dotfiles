#!/usr/bin/env bash
# Dotfiles setup script

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.1.7

set -euo pipefail

# Configuration variables
declare REPO_URL="https://github.com/RustyTake-Off/dotfiles.git"
declare DOTFILES_PATH="$HOME/.dotfiles"
declare BRANCH_NAME="wslfiles"

# ANSI escape sequences for different colors
declare -A COLORS=(
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
  echo -e "${COLORS[$color]}${message}${COLORS[reset]}"
}

# Main logic
# Check if Git is installed
if [ ! -x "$(command -v git)" ]; then
  write_colored_message "Git is not installed" "red"
  exit 1
fi

# Clone dotfiles
if [ ! -d "$DOTFILES_PATH" ]; then
  write_colored_message "Cloning dotfiles..." "yellow"

  git clone --bare "$REPO_URL" "$DOTFILES_PATH"
  git --git-dir="$DOTFILES_PATH" --work-tree="$HOME" checkout "$BRANCH_NAME"
  git --git-dir="$DOTFILES_PATH" --work-tree="$HOME" config status.showUntrackedFiles no
else
  write_colored_message "Dotfiles are set" "yellow"
  write_colored_message "Checking for updates..." "purple"

  git --git-dir="$DOTFILES_PATH" --work-tree="$HOME" reset --hard
  git --git-dir="$DOTFILES_PATH" --work-tree="$HOME" pull origin "$BRANCH_NAME"
fi
