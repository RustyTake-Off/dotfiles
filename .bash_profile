# Loads bashrc
if [ -n "$BASH_VERSION" ]; then
  [ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"
fi
