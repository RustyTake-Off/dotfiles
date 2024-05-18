#!/usr/bin/env bash
# Various functions

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.1.0

function rebash() {
  # Reload bashrc

  if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
  fi
}

function extract() {
  # Extracts any archive(s)

  for archive in "$@"; do
    if [ -f "$archive" ]; then
      case $archive in
        *.tar.bz2)   tar xvjf "$archive"    ;;
        *.tar.gz)    tar xvzf "$archive"    ;;
        *.bz2)       bunzip2 "$archive"     ;;
        *.rar)       rar x "$archive"       ;;
        *.gz)        gunzip "$archive"      ;;
        *.tar)       tar xvf "$archive"     ;;
        *.tbz2)      tar xvjf "$archive"    ;;
        *.tgz)       tar xvzf "$archive"    ;;
        *.zip)       unzip "$archive"       ;;
        *.Z)         uncompress "$archive"  ;;
        *.7z)        7z x "$archive"        ;;
        *)           echo "Cannot extract '$archive'..." ;;
      esac
    else
      echo "'$archive' is not a valid file!"
    fi
  done
}

function cpkeys() {
  # Copy keys from Windows host directory
  # Note: Use the same user name in WSL as in Windows

  keys_path="/mnt/c/Users/$LOGNAME/.ssh"
  find $keys_path -maxdepth 1 -type f -name '*.pub' | while read -r file; do
    cp "$keys_path/$(basename "$file" .pub)" --target-directory "$HOME/.ssh"
    cp "$keys_path/$(basename "$file")" --target-directory "$HOME/.ssh"
  done
}

function permkeys() {
  # Removes read, write and execute permissions from group and others

  find "$HOME/.ssh" -maxdepth 1 -type f -name '*.pub' | while read -r file; do
    chmod go-rwx "$HOME/.ssh/$(basename "$file" .pub)"
    chmod go-rwx "$HOME/.ssh/$(basename "$file")"
  done
}
