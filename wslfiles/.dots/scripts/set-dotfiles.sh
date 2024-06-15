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
wslfilesPath="$HOME/wslfiles"
declare -A toCheckout=(
  ["wslfiles"]=(".config" ".dots" ".bash_logout" ".bash_profile" ".bashrc" ".gitconfig" ".hushlogin" ".inputrc")
)

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
if [[ ! $skipDotfiles ]]; then
  if ! command -v git >/dev/null; then
    write_colored_message "Git is not installed" "red"
    exit 1
  fi

  if [[ ! -d $dotfilesPath ]]; then
    paths=()
    for category in "${!toCheckout[@]}"; do
      for item in ${toCheckout[$category]}; do
        paths+=("$category/$item")
      done
    done

    write_colored_message "Cloning dotfiles..." "yellow"

    git clone --bare "$repoUrl" "$dotfilesPath"
    git --git-dir="$dotfilesPath" --work-tree="$HOME" checkout "${paths[@]}"
    git --git-dir="$dotfilesPath" --work-tree="$HOME" config status.showUntrackedFiles no

    # Move files
    if [[ -d $wslfilesPath ]]; then
      for item in ${toCheckout["wslfiles"]}; do
        sourcePath="$wslfilesPath/$item"
        if [[ -d $sourcePath ]]; then
          find "$sourcePath" -mindepth 1 -maxdepth 1 -exec mv -t "$HOME" {} +
        elif [[ -f $sourcePath ]]; then
          mv "$sourcePath" "$HOME"
        fi
      done
    else
      write_colored_message "Directory 'wslfiles' not found in '$HOME'" "red"
      exit 1
    fi
  else
    write_colored_message "Dotfiles are set. Checking for updates..." "yellow"

    git --git-dir="$dotfilesPath" --work-tree="$HOME" reset --hard
    git --git-dir="$dotfilesPath" --work-tree="$HOME" pull

    # Move files
    if [[ -d $wslfilesPath ]]; then
      for item in ${toCheckout["wslfiles"]}; do
        sourcePath="$wslfilesPath/$item"
        if [[ -d $sourcePath ]]; then
          find "$sourcePath" -mindepth 1 -maxdepth 1 -exec mv -t "$HOME" {} +
        elif [[ -f $sourcePath ]]; then
          mv "$sourcePath" "$HOME"
        fi
      done
    else
      write_colored_message "Directory 'wslfiles' not found in '$HOME'" "red"
      exit 1
    fi
  fi
else
  write_colored_message "Skipping dotfiles" "yellow"
fi
