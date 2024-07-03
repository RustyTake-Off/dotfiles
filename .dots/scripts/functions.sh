#!/usr/bin/env bash
# Various functions

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.2.1

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
  # Copy keys and config from Windows .ssh directory and
  # removes read, write and execute permissions from group and others

  uname -r | grep -q "WSL2" || echo "Needs to be run on WSL2" && exit
  win_user="$(command powershell.exe '$env:USERNAME')"
  keys_path="/mnt/c/Users/${win_user//$'\r'/}/.ssh"

  find $keys_path -maxdepth 1 -type f -name 'config' | while read -r file; do
    cp "$file" --target-directory "$HOME/.ssh"
  done
  find $keys_path -maxdepth 1 -type f -name '*.pub' | while read -r file; do
    base_name="$(basename "$file" .pub)"
    cp "$keys_path/$base_name.pub" --target-directory "$HOME/.ssh" && \
    chmod go-rwx "$HOME/.ssh/$base_name.pub"
    cp "$keys_path/$base_name" --target-directory "$HOME/.ssh" && \
    chmod go-rwx "$HOME/.ssh/$base_name"
  done
}

function permkeys() {
  # Removes read, write and execute permissions from group and others

  find "$HOME/.ssh" -maxdepth 1 -type f -name '*.pub' | while read -r file; do
    base_name="$(basename "$file" .pub)"
    chmod go-rwx "$HOME/.ssh/$base_name.pub"
    chmod go-rwx "$HOME/.ssh/$base_name"
  done
}
