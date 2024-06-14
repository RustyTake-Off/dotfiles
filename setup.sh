#!/usr/bin/env bash
# Dotfiles setup script

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.1.0

set -euo pipefail

# Configuration variables
repoUrl='https://github.com/RustyTake-Off/dotfiles.git'
dotfilesPath="$HOME/.dotfiles"
wslfilesPath="$HOME/wslfiles"
dotfilesScriptPath="$HOME/.dots/scripts/set-dotfiles.sh"
declare -A toCheckout=(
    ["wslfiles"]=(".config" ".dots" ".bash_logout" ".bash_profile" ".bashrc" ".gitconfig" ".hushlogin" ".inputrc")
)

# ANSI escape sequences for different colors
declare -A colors=(
    ["red"]="\033[31m"
    ["green"]="\033[32m"
    ["yellow"]="\033[33m"
    ["reset"]="\033[0m"
)

# Function definitions
function write_colored_message {
    local message="$1"
    local color="$2"
    echo -e "${colors[$color]}$message${colors[reset]}"
}

function check_and_ask_to_install {
    local package_name="$1"
    if command -v "$package_name" &> /dev/null; then
        return 1
    fi

    write_colored_message "$package_name is not installed" "red"

    while true; do
        read -rp "Do you want to install ${colors[yellow]}$package_name${colors[reset]} (y/N)? " choice
        choice=$(echo "$choice" | tr '[:upper:]' '[:lower:]' | xargs)

        case "$choice" in
            y) return 0 ;;
            n) write_colored_message "Stopping script. Bye, bye" "red"; exit 1 ;;
            *) write_colored_message "Invalid input, please enter 'y' or 'n'" "red" ;;
        esac
    done
}

# Main logic
# Check and install git
if ! check_and_ask_to_install "git"; then
    write_colored_message "Installing Git..." "yellow"
    sudo apt update && sudo apt install -y git
    write_colored_message "Installed Git" "green"
else
    write_colored_message "Git is installed" "green"
fi

# Clone dotfiles
if [[ ! -d "$dotfilesPath" ]]; then
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
else
    write_colored_message "Directory '.dotfiles' already exists in '$HOME'" "red"
    exit 1
fi

# Move wslfiles
if [[ -d "$wslfilesPath" ]]; then
    for item in ${toCheckout['wslfiles']}; do
        sourcePath="$wslfilesPath/$item"
        if [[ -d "$sourcePath" ]]; then
            find "$sourcePath" -mindepth 1 -maxdepth 1 -exec mv -t "$HOME" {} +
        elif [[ -f "$sourcePath" ]]; then
            mv -f "$sourcePath" "$HOME"
        fi
    done
else
    write_colored_message "Directory 'wslfiles' not found in '$HOME'" "red"
    exit 1
fi

# Run dotfiles script
if [[ -f "$dotfilesScriptPath" ]]; then
    write_colored_message "Setting dotfiles..." "yellow"
    command bash "$dotfilesScriptPath" --skip-dotfiles
    write_colored_message "Dotfiles are set" "green"
else
    write_colored_message "Script file in path '$dotfilesScriptPath' does not exist" "red"
    exit 1
fi
