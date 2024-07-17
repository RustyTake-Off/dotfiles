# Bashrc config

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Exports
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export HISTTIMEFORMAT="%d-%m %H:%M:%S  "
export HISTCONTROL=erasedups:ignorespace
export HISTIGNORE="&:ls:la:ll:cd:exit:pwd:cls:[ ]*"
export TERM="xterm-256color"
export EDITOR="vim"

# Set vim as MANPAGER - https://zameermanji.com/blog/2012/12/30/using-vim-as-manpager/
# export MANPAGER="/usr/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

# Set PATH to user's private bin
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

# Misc exports
export AZURE_DEV_COLLECT_TELEMETRY=no
export HOMEBREW_NO_ANALYTICS=1
export PYENV_ROOT="$HOME/.pyenv"
export RYE_HOME="$HOME/.rye"
export NVM_DIR="$HOME/.nvm"

# Init apps
[ -x "$(command -v /home/linuxbrew/.linuxbrew/bin/brew)" ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && source "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"
[ -x "$(command -v starship)" ] && eval "$(starship init bash)"
[ -x "$(command -v zoxide)" ] && eval "$(zoxide init bash)"
[ -x "$(command -v pyenv)" ] && eval "$(pyenv init -)"
[ -x "$(command -v rye)" ] && source "$HOME/.rye/env"
[ -x "$(command -v fzf)" ] && eval "$(fzf --bash)"

# Load bash files
bash_config_files="aliases functions completions shell_options"
for file in $bash_config_files; do
  if [ -f "$HOME/.dots/scripts/$file.sh" ]; then
    source "$HOME/.dots/scripts/$file.sh"
  fi
done
unset bash_config_files
