#!/usr/bin/env bash
# Dotfiles setup script

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.1.2

set -euo pipefail

# Configuration variables
repoUrl="https://github.com/RustyTake-Off/dotfiles.git"
dotfilesPath="$HOME/.dotfiles"
wslfilesPath="wslfiles"

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
function write_colored_message() {
  # Color message

  local message=$1
  local color=$2
  echo -e "${colors[$color]}$message${colors["reset"]}"
}

# Main logic
# Clone dotfiles
if [ ! -x "$(command -v git)" ]; then
  write_colored_message "Git is not installed" "red"
  exit 1
fi

if [ ! -d $dotfilesPath ]; then
  write_colored_message "Cloning dotfiles..." "yellow"

  git clone --bare "$repoUrl" "$dotfilesPath"
  git --git-dir="$dotfilesPath" --work-tree="$HOME" checkout $wslfilesPath
  git --git-dir="$dotfilesPath" --work-tree="$HOME" config status.showUntrackedFiles no
else
  write_colored_message "Dotfiles are set." "yellow"
  write_colored_message "Checking for updates..." "purple"

  git --git-dir="$dotfilesPath" --work-tree="$HOME" reset --hard
  git --git-dir="$dotfilesPath" --work-tree="$HOME" pull origin $wslfilesPath
fi
