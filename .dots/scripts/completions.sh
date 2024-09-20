#!/usr/bin/env bash
# Completions for various cli tools

# GitHub        - https://github.com/RustyTake-Off
# GitHub Repo   - https://github.com/RustyTake-Off/dotfiles
# Author        - RustyTake-Off

# Completions for bash
if [[ -f "/usr/share/bash-completion/bash_completion" ]]; then
  source "/usr/share/bash-completion/bash_completion"
elif [[ -f "/etc/bash_completion" ]]; then
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
if [[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ]]; then
  source "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
fi

# Completions for pip/pip3
# if [[ -x "$(command -v pip)" ]]; then
#   source <(pip completion --bash)
#   source <(pip3 completion --bash)
# fi

# Completions for azcli
if [[ -x "$(command -v az)" ]]; then
  source "$HOME/lib/azure-cli/az.completion"
fi

# Completions for npm
if [[ -x "$(command -v npm)" ]]; then
  source <(npm completion)
fi

# Completions for node
# if [[ -x "$(command -v node)" ]]; then
#   source <(node --completion-bash)
# fi
