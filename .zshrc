# Zsh-specific shell bootstrap.

export SHELL=${SHELL:-/bin/zsh}

if [ -f "$HOME/.shellrc" ]; then
  . "$HOME/.shellrc"
fi
