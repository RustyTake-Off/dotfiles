#!/usr/bin/env bash
# Completions for various cli tools

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off
# Version       - 0.1.0

# Completions for bash
if [ -f /usr/share/bash-completion/bash_completion ]; then
  source "/usr/share/bash-completion/bash_completion"
elif [ -f /etc/bash_completion ]; then
  source "/etc/bash_completion"
fi

# Completions for brew
if [ -f "$(command -v /home/linuxbrew/.linuxbrew/bin/brew)" ]; then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*; do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

# Completions for nvm
if [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]; then
  source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
fi
