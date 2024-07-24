#!/usr/bin/env bash
# Various functions

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.2.3

rebash() {
  # Reload bashrc

  if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
  fi
}

extract() {
  # Extracts any archive(s)

  for archive in "$@"; do
    if [ -f "$archive" ]; then
      case "${archive,,}" in
        *.tar.bz2)   tar xvjf "$archive"    ;;
        *.tar.gz)    tar xvzf "$archive"    ;;
        *.bz2)       bunzip2 "$archive"     ;;
        *.rar)       rar x "$archive"       ;;
        *.gz)        gunzip "$archive"      ;;
        *.tar)       tar xvf "$archive"     ;;
        *.tbz2)      tar xvjf "$archive"    ;;
        *.tgz)       tar xvzf "$archive"    ;;
        *.zip)       unzip "$archive"       ;;
        *.z)         uncompress "$archive"  ;;
        *.7z)        7z x "$archive"        ;;
        *)           echo "Cannot extract '$archive'..." ;;
      esac
    else
      echo "'$archive' is not a valid file!"
    fi
  done
}

cpkeys() {
  # Copy keys and config from Windows .ssh directory and
  # removes read, write and execute permissions from group and others

  if ! uname -r | grep -q "WSL2"; then
    echo "Needs to be run on WSL2"
    exit 1
  fi

  win_user="$(command powershell.exe '$env:USERNAME' | tr --delete '\r')"
  keys_path="/mnt/c/Users/${win_user}/.ssh"

  mkdir -p "$HOME/.ssh"

  # Copy SSH config file if it exists
  find "$keys_path" -maxdepth 1 -type f -name 'config' | while read -r file; do
    cp "$file" "$HOME/.ssh"
  done

  # Copy and set permissions for public and private keys
  find "$keys_path" -maxdepth 1 -type f -name '*.pub' | while read -r file; do
    base_name="$(basename "$file" .pub)"
    cp "$file" "$HOME/.ssh" && chmod go-rwx "$HOME/.ssh/$base_name.pub"
    cp "$keys_path/$base_name" "$HOME/.ssh" && chmod go-rwx "$HOME/.ssh/$base_name"
  done
}

permkeys() {
  # Removes read, write and execute permissions from group and others

  find "$HOME/.ssh" -maxdepth 1 -type f -name '*.pub' | while read -r file; do
    base_name="$(basename "$file" .pub)"
    chmod go-rwx "$file"
    if [ -f "$HOME/.ssh/$base_name" ]; then
      chmod go-rwx "$HOME/.ssh/$base_name"
    fi
  done
}
