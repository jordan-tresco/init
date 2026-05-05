#!/usr/bin/env bash
set -euo pipefail

OS=$(uname -s)

log() {
  printf '==> %s\n' "$*"
}

require_linux_root() {
  if [ "$OS" = "Linux" ] && [ "${EUID:-$(id -u)}" -ne 0 ]; then
    printf 'On Linux, this script must be run as root. Use sudo ./init-system.sh\n' >&2
    exit 1
  fi
}

require_macos_user() {
  if [ "$OS" = "Darwin" ] && [ "${EUID:-$(id -u)}" -eq 0 ]; then
    printf 'On macOS, run this script as your normal user so Homebrew can manage packages correctly.\n' >&2
    exit 1
  fi
}

require_command() {
  command -v "$1" >/dev/null 2>&1
}

install_homebrew_for_current_user() {
  if require_command brew; then
    return
  fi

  log "Homebrew is not installed"
  printf 'Install Homebrew as the target user first, then rerun init-system.sh.\n' >&2
  exit 1
}

install_fedora_packages() {
  log "Installing Fedora system packages"
  dnf -y install \
    cmake \
    freetype-devel \
    fontconfig-devel \
    libxcb-devel \
    libxkbcommon-devel \
    gcc-c++ \
    openssl-devel \
    sqlite-devel \
    python3-tkinter \
    ncurses-devel \
    perl \
    helix \
    curl \
    git \
    unzip \
    wget \
    fontconfig
  dnf -y group install "Development Tools"
  dnf -y install dnf-plugins-core
  dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo || true
  dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || true
}

install_macos_packages() {
  install_homebrew_for_current_user

  log "Installing macOS packages with Homebrew"
  brew install \
    cmake \
    freetype \
    fontconfig \
    libxcb \
    libxkbcommon \
    openssl \
    sqlite \
    tcl-tk \
    perl \
    helix \
    git \
    wget

  brew install --cask docker || true
  brew tap homebrew/cask-fonts || true
  brew install --cask font-fira-code-nerd-font || true
}

main() {
  require_linux_root
  require_macos_user

  case "$OS" in
    Linux)
      install_fedora_packages
      ;;
    Darwin)
      install_macos_packages
      ;;
    *)
      printf 'Unsupported operating system: %s\n' "$OS" >&2
      exit 1
      ;;
  esac

  log "System bootstrap complete"
}

main "$@"
