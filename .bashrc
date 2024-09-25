# Bashrc config

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Exports
export EDITOR="vim"
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export HISTTIMEFORMAT="%d-%m %H:%M:%S  "
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="&:ls:la:ll:rebash:exit:pwd:cls:clear:h *:hfl *:z *:al *:git alias *:[ ]*"
export TERM="xterm-256color"

# Set vim as MANPAGER - https://zameermanji.com/blog/2012/12/30/using-vim-as-manpager/
# export MANPAGER="/usr/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

# Set PATH to user's private bin
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"

# Misc exports
export AZURE_DEV_COLLECT_TELEMETRY=no
export HOMEBREW_NO_ANALYTICS=1

# Init apps
[ -x "$(command -v /home/linuxbrew/.linuxbrew/bin/brew)" ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && source "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"
[ -x "$(command -v starship)" ] && eval "$(starship init bash)"
[ -x "$(command -v zoxide)" ] && eval "$(zoxide init bash)"
[ -x "$(command -v goenv)" ] && eval "$(goenv init -)" \
&& export PATH="$GOROOT/bin:$PATH"; export PATH="$PATH:$GOPATH/bin"
[ -x "$(command -v fzf)" ] && eval "$(fzf --bash)"
[ -x "$(command -v uv)" ] && eval "$(uv generate-shell-completion bash)"
[ -x "$(command -v uvx)" ] && eval "$(uvx --generate-shell-completion bash)"

# Load bash files
declare bash_config_files=("aliases" "functions" "completions" "shell_options")
for file in "${bash_config_files[@]}"; do
  if [ -f "$HOME/.dots/scripts/$file.sh" ]; then
    source "$HOME/.dots/scripts/$file.sh"
  fi
done
unset -v bash_config_files file
