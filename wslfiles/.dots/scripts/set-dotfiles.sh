#!/usr/bin/env bash
# ╒══════╗        ╒═══════╗
# │ ╓──┐ ║════════╗  ╓─┐  ║
# │ ╚══╛ ║──┐  ╓──╜  ║ │  ║  RustyTake-Off
# │ ╓─┐ ╓╜  │  ║  │  ║ │  ║  https://github.com/RustyTake-Off
# │ ║ │ ╚╗  │  ║  │  ╚═╛  ║
# └─╜ └──╜  └──╜  └───────╜
# Script for setting up WSL dotfiles.

# Repository      -   "https://github.com/RustyTake-Off/wsl-dotfiles",
# Script file     -   "https://github.com/RustyTake-Off/wsl-dotfiles/blob/main/.local/bin/set-dotfiles.sh"

# ================================================================================
# Main variables

REPO_URL="https://github.com/RustyTake-Off/wsl-dotfiles.git"

# ================================================================================
# Main code

# Invokes dotfiles setup script
if [ -d "$HOME/.dotfiles" ]; then
  if [ -f "$(command -v git)" ]; then
    git clone --bare "$REPO_URL" "$HOME/.dotfiles"
    git --git-dir="$HOME\.dotfiles" --work-tree="$HOME" checkout
    git --git-dir="$HOME\.dotfiles" --work-tree="$HOME" config status.showUntrackedFiles no
  else
    echo "Git is not installed!"
  fi
else
  echo "Dotfiles are set"
  echo "Checking for updates"
  git --git-dir="$HOME\.dotfiles" --work-tree="$HOME" reset --hard
  git --git-dir="$HOME\.dotfiles" --work-tree="$HOME" pull
fi
