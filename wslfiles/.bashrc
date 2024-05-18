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

# Set vim as MANPAGER: https://zameermanji.com/blog/2012/12/30/using-vim-as-manpager/
export MANPAGER="/usr/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

bash_config_files="aliases functions completions"
if [ -d "$HOME/.dots" ]; then
  for file in $bash_config_files; do
    if [ -f "$HOME/.dots/$file.sh" ]; then
      source "$HOME/.dots/$file.sh"
    fi
  done
fi
unset bash_config_files

[ -f "$(command -v /home/linuxbrew/.linuxbrew/bin/brew)" ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && source "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"
[ -f "$(command -v starship)" ] && eval "$(starship init bash)"
[ -f "$(command -v zoxide)" ] && eval "$(zoxide init bash)"
[ -f "$(command -v fzf)" ] && eval "$(fzf --bash)"

# Set up SSH agent for key management
# {
#   if eval "$(ssh-agent -s)"; then
#     keys="pr-ed-key wk-ed-key"
#     for key in $keys; do
#       file="$HOME/.ssh/$key"
#       if [ -e "$file" ]; then
#         chmod go-rwx "$HOME/.ssh/$key"
#         ssh-add "$HOME/.ssh/$key"
#       fi
#     done
#     trap 'kill $SSH_AGENT_PID' EXIT
#   fi
# } 1> /dev/null 2>&1
# unset keys key file

# Set optional shell behavior: https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html
shopt -s autocd
shopt -s cdspell
shopt -s checkhash
shopt -s checkwinsize
shopt -s cmdhist
shopt -s complete_fullquote
shopt -s direxpand
shopt -s dirspell
shopt -s expand_aliases
shopt -s extglob
shopt -s extquote
shopt -s force_fignore
shopt -s globasciiranges
shopt -s globstar
shopt -s histappend
shopt -s hostcomplete
shopt -s interactive_comments
shopt -s lithist
shopt -s no_empty_cmd_completion
shopt -s nocasematch
shopt -s progcomp
shopt -s promptvars
shopt -s sourcepath
shopt -s xpg_echo

# Set shell options: https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html
set -o braceexpand
set -o emacs
set -o hashall
set -o histexpand
set -o monitor
