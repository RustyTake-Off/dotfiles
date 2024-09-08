#!/usr/bin/env bash
# Various functions

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.2.4

rebash() {
  # Reload bashrc

  if [ -f "$HOME/.bashrc" ]; then
    source "$HOME/.bashrc"
  fi
}

iam() {
  # Shortcut for different whoami commands

  local cmd="whoami"
  local commands="whoami who w uname users groups passwd group shadow lastlog last id finger pinky"

  [ $# -eq 0 ] || cmd="${1,,}"

  if [ -z "$(echo "$commands" | grep -w "$cmd")" ]; then
    echo "Error: Invalid command. Please use one of the following:"
    echo "$commands\n" | tr ' ' ', '
    return 1
  fi

  case "$cmd" in
    passwd)   [ -r "/etc/passwd" ] && cat /etc/passwd || \
              echo "Error: Cannot read /etc/passwd. Permission denied." && \
              return 1
              ;;

    group)    [ -r "/etc/group" ] && cat /etc/group || \
              echo "Error: Cannot read /etc/group. Permission denied." && \
              return 1
              ;;

    shadow)   [ -r "/etc/shadow" ] && sudo cat /etc/shadow || \
              echo "Error: Cannot read /etc/shadow. Permission denied or sudo required." && \
              return 1
              ;;

    uname)    uname -a
              ;;

    *)        [ "$(command -v "$cmd")" ] && $cmd || \
              echo "Error: The command '$cmd' is not installed on this system." && \
              return 1
              ;;
  esac
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

  if [ ! "$(uname -r | grep 'WSL2')" ]; then
    echo "Needs to be run on WSL2"
    return
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

prwk() {
  # Backup or recover pr and wk directories in WSL
  # Usage: prwk {back|rec}

  if [ ! "$(uname -r | grep 'WSL2')" ]; then
    echo "Needs to be run on WSL2"
    return 1
  fi

  local action="$1"
  local pr_dir_path="$HOME/pr"
  local wk_dir_path="$HOME/wk"

  win_user="$(command powershell.exe '$env:USERNAME' | tr --delete '\r')"
  local backup_pr_dir_path="/mnt/c/Users/${win_user}/pr_wsl_backup"
  local backup_wk_dir_path="/mnt/c/Users/${win_user}/wk_wsl_backup"

  case "$action" in
      back)
          echo "You are about to back up directories"
          echo "Source directories: $pr_dir_path and $wk_dir_path"
          echo "Backup locations: $backup_pr_dir_path and $backup_wk_dir_path"
          read -p "Are you sure you want to proceed? (y/n): " choice
          if [[ "${choice,,}" == "y" ]]; then
              mkdir -p "$backup_pr_dir_path"
              mkdir -p "$backup_wk_dir_path"
              cp -rT "$pr_dir_path" "$backup_pr_dir_path"
              cp -rT "$wk_dir_path" "$backup_wk_dir_path"
              echo "Backup completed"
          else
              echo "Backup canceled"
          fi
          ;;
      rec)
          echo "You are about to recover directories"
          echo "Backup locations: $backup_pr_dir_path and $backup_wk_dir_path"
          echo "Destination directories: $pr_dir_path and $wk_dir_path"
          read -p "Are you sure you want to proceed? (y/n): " choice
          if [[ "${choice,,}" == "y" ]]; then
              cp -rT "$backup_pr_dir_path" "$pr_dir_path"
              cp -rT "$backup_wk_dir_path" "$wk_dir_path"
              echo "Recovery completed"
          else
              echo "Recovery canceled"
          fi
          ;;
      *)
          echo "Usage: prwk {back|rec}"
          ;;
  esac
}
