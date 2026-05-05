#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
SELF=$(basename "$0")

usage() {
  cat <<USAGE
Usage:
  ./$SELF user      Run user bootstrap in the current account
  ./$SELF system    Run system bootstrap for the current platform
  ./$SELF all       Run system bootstrap first, then user bootstrap

Recommended order:
  Linux: sudo ./init-system.sh && ./init-user.sh
  macOS: ./init-system.sh && ./init-user.sh
USAGE
}

run_system() {
  exec "$ROOT_DIR/init-system.sh"
}

run_user() {
  exec "$ROOT_DIR/init-user.sh"
}

main() {
  local mode=${1:-}

  case "$mode" in
    system)
      run_system
      ;;
    user)
      run_user
      ;;
    all)
      if [ "${EUID:-$(id -u)}" -eq 0 ]; then
        printf 'Do not run "%s all" as root. Run sudo ./init-system.sh, then ./init-user.sh as your normal user.\n' "$SELF" >&2
        exit 1
      fi

      if [ "$(uname -s)" = "Linux" ]; then
        printf 'Running Linux system bootstrap with sudo.\n'
        sudo "$ROOT_DIR/init-system.sh"
      else
        printf 'Running macOS system bootstrap as the current user.\n'
        "$ROOT_DIR/init-system.sh"
      fi
      "$ROOT_DIR/init-user.sh"
      ;;
    -h|--help|help|"")
      usage
      ;;
    *)
      printf 'Unknown mode: %s\n\n' "$mode" >&2
      usage >&2
      exit 1
      ;;
  esac
}

main "$@"
