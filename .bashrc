# Bash-specific shell bootstrap.

if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

if [ -f "$HOME/.shellrc" ]; then
  . "$HOME/.shellrc"
fi
