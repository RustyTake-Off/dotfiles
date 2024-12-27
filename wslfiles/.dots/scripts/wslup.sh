#!/usr/bin/env bash
# WSL setup script

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off

# Configuration variables
dotfiles_script_path="$HOME/.dots/scripts/set_dotfiles.sh"
declare home_dirs=("pr" "wk")

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
  echo -e "${colors[$color]}$message${colors[reset]}"
}

get_help() {
  # Help message

  write_colored_message "Available commands:" "yellow"
  echo -e "${colors[yellow]}  -h    |  --help      ${colors[reset]} - Prints help message"
  echo -e "${colors[yellow]}  -a    |  --apt-apps  ${colors[reset]} - Installs apt applications"
  echo -e "${colors[yellow]}  -c    |  --cr-dirs   ${colors[reset]} - Creates home directories"
  echo -e "${colors[yellow]}  -b    |  --brew      ${colors[reset]} - Installs homebrew"
  echo -e "${colors[yellow]}  -ba   |  --brew-apps ${colors[reset]} - Installs brew applications"
  echo -e "${colors[yellow]}  -d    |  --dotfiles  ${colors[reset]} - Invokes dotfiles setup script"
  echo -e "${colors[yellow]}  -all  |  --all       ${colors[reset]} - Creates home directories, installs apt and brew applications"
}

create_dirs() {
  # Create directories
  for dir in "${home_dirs[@]}"; do
    if [[ ! -d "$HOME/$dir" ]]; then
      echo -e "Creating ${colors[yellow]}'$dir'${colors[reset]} directory"
      mkdir -p "$HOME/$dir"
    fi
  done

  # Copy gitconfigs if on WSL2/Microsoft
  if [[ "$(grep -wE 'WSL2|Microsoft' <(uname -r))" ]]; then
    win_user="$(command powershell.exe '$env:USERNAME')"
    win_home_path="/mnt/c/Users/${win_user//$'\r'/}"

    for dir in "${home_dirs[@]}"; do
      win_file_path="$win_home_path/$dir/$dir.gitconfig"
      local_file_path="$HOME/$dir/$dir.gitconfig"

      if [[ -f "$win_file_path" ]]; then
          echo -e "Copying ${colors[yellow]}'$dir.gitconfig'${colors[reset]}"
          cp "$win_file_path" "$local_file_path"
      else
        echo -e "File ${colors[red]}'$dir.gitconfig'${colors[reset]} does not exist in '$win_home_path/$dir'."
      fi
    done
  fi
}

get_apt_apps() {
  # Install some prerequisite and utility apps

  write_colored_message "Updating and upgrading apt packages..." "yellow"
  sudo apt update && sudo apt upgrade -y

  write_colored_message "Installing prerequisite and utility apps..." "yellow"
  sudo apt install -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    gnupg \
    gpg \
    make \
    net-tools \
    python3-pip \
    python3-venv \
    software-properties-common \
    tree \
    unzip \
    wget
}

get_brew() {
  # Install homebrew if not installed

  if [[ ! -x "$(command -v brew)" ]]; then
    write_colored_message "Installing Homebrew..." "yellow"
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Check if Homebrew is installed and set up the environment
    if [[ -x "$(command -v /home/linuxbrew/.linuxbrew/bin/brew)" ]]; then
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      command brew completions link

      write_colored_message "Homebrew installed and configured" "green"
    fi
  else
    write_colored_message "Homebrew already installed" "green"
  fi
}

get_brew_apps() {
  # Install homebrew apps

  # Check and install homebrew
  get_brew

  if [[ -x "$(command -v brew)" ]]; then
    write_colored_message "Installing Homebrew apps..." "yellow"
    brew install \
      ansible \
      azure-cli \
      entr \
      fzf \
      gh \
      git \
      goenv \
      helm \
      jq \
      k9s \
      kubecm \
      kubectx \
      kubent \
      kubernetes-cli \
      nvm \
      ripgrep \
      shellcheck \
      shfmt \
      starship \
      tenv \
      tlrc \
      trash-cli \
      uv \
      yq \
      zoxide
  fi

}

misc_config() {
  # Set miscellaneous configurations

  write_colored_message "Setting miscellaneous configurations..." "yellow"

  [[ -x "$(command -v az)" ]] && {
    az config set core.collect_telemetry=false
  }
}

set_dotfiles() {
  # Invokes dotfiles setup script

  write_colored_message "Invoking dotfiles setup script..." "yellow"

  if [[ -x "$DOTFILES_SCRIPT_PATH" ]]; then
    source "$DOTFILES_SCRIPT_PATH"
  else
    curl -fsS https://raw.githubusercontent.com/RustyTake-Off/dotfiles/main/wslfiles/.dots/scripts/set_dotfiles.sh | bash
  fi

  write_colored_message "Invocation complete" "green"
}

# Main logic
if [[ $# -eq 0 ]]; then
  get_help
else
  case "$1" in
    -h|--help)
      get_help
      ;;
    -c|--cr-dirs)
      create_dirs
      ;;
    -a|--apt-apps)
      get_apt_apps
      ;;
    -b|--brew)
      get_brew
      ;;
    -ba|--brew-apps)
      get_brew_apps
      misc_config
      ;;
    -d|--dotfiles)
      set_dotfiles
      ;;
    -all|--all)
      create_dirs
      get_apt_apps
      get_brew
      get_brew_apps
      misc_config
      ;;
    *)
	    write_colored_message "Invalid command: $1\n" "red"
      get_help
      ;;
  esac
fi
