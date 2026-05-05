#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
OS=$(uname -s)
PROJECTS_DIR=${PROJECTS_DIR:-"$HOME/projects"}
DEPENDENCIES_DIR=${DEPENDENCIES_DIR:-"$HOME/dependencies"}
MISE_BIN_DEFAULT=${MISE_BIN_DEFAULT:-"$HOME/.local/bin/mise"}

log() {
  printf '==> %s\n' "$*"
}

require_not_root() {
  if [ "${EUID:-$(id -u)}" -eq 0 ]; then
    printf 'This script must be run as your normal user, not root.\n' >&2
    exit 1
  fi
}

require_command() {
  command -v "$1" >/dev/null 2>&1
}

append_line_if_missing() {
  local file=$1
  local line=$2

  touch "$file"
  if ! grep -Fqx "$line" "$file"; then
    printf '%s\n' "$line" >> "$file"
  fi
}

warn_missing_system_dependencies() {
  local missing=0
  local cmd

  for cmd in git curl; do
    if ! require_command "$cmd"; then
      printf 'Missing required system dependency: %s\n' "$cmd" >&2
      missing=1
    fi
  done

  case "$OS" in
    Linux)
      for cmd in gcc cmake perl; do
        if ! require_command "$cmd"; then
          printf 'Missing recommended Linux dependency: %s\n' "$cmd" >&2
          missing=1
        fi
      done
      ;;
    Darwin)
      if ! require_command brew; then
        printf 'Homebrew is not available; system packages will not be installed automatically.\n' >&2
      fi
      ;;
  esac

  if [ "$missing" -eq 1 ]; then
    printf 'Install the missing dependencies with init-system.sh or through your administrator.\n' >&2
  fi
}

install_rust() {
  if require_command cargo; then
    return
  fi

  log "Installing Rust"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  # shellcheck disable=SC1090
  . "$HOME/.cargo/env"
}

install_mise() {
  if require_command mise; then
    return
  fi

  if [ -x "$MISE_BIN_DEFAULT" ]; then
    return
  fi

  log "Installing mise"
  curl https://mise.run | sh
}

install_starship() {
  if require_command starship; then
    return
  fi

  log "Installing starship"
  curl -sS https://starship.rs/install.sh | sh -s -- -y
}

install_cargo_tools() {
  log "Installing cargo tools"
  cargo install --locked zellij bottom bat exa ripgrep onefetch
}

install_shell_files() {
  log "Installing shell rc files"
  install -m 0644 "$ROOT_DIR/.shellrc" "$HOME/.shellrc"
  install -m 0644 "$ROOT_DIR/.bashrc" "$HOME/.bashrc"
  install -m 0644 "$ROOT_DIR/.zshrc" "$HOME/.zshrc"

  if [ "$OS" = "Darwin" ] && [ -x /opt/homebrew/bin/brew ]; then
    append_line_if_missing "$HOME/.zprofile" 'eval "$(/opt/homebrew/bin/brew shellenv)"'
  fi
}

install_dotfiles() {
  log "Copying dotfiles into ~/.config"
  mkdir -p "$HOME/.config"
  cp -a "$ROOT_DIR/dotfiles/." "$HOME/.config"
}

configure_bat() {
  if require_command bat; then
    bat cache --build || true
  elif require_command batcat; then
    batcat cache --build || true
  fi
}

install_linux_font() {
  local zip_path font_dir

  zip_path="$HOME/Downloads/FiraCode.zip"
  font_dir="$HOME/.local/share/fonts/FiraCode"

  mkdir -p "$HOME/Downloads" "$font_dir"
  wget -O "$zip_path" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraCode.zip
  unzip -o "$zip_path" -d "$font_dir"
  fc-cache -f "$font_dir" || true
}

prepare_directories() {
  log "Creating project directories"
  mkdir -p "$PROJECTS_DIR" "$DEPENDENCIES_DIR"
}

main() {
  require_not_root
  warn_missing_system_dependencies
  install_rust
  install_mise
  install_starship
  install_cargo_tools
  install_dotfiles
  install_shell_files
  configure_bat

  if [ "$OS" = "Linux" ]; then
    install_linux_font
  fi

  prepare_directories
  log "User bootstrap complete"
}

main "$@"
