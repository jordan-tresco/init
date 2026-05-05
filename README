### README

This repository bootstraps a shared shell and terminal setup on Fedora and macOS.

## supported environments
- Fedora with `bash`
- macOS with `zsh`

## bootstrap
The bootstrap is now split into system-level and user-level steps.

System bootstrap:

```bash
# Fedora / Linux
sudo ./init-system.sh

# macOS
./init-system.sh
```

macOS prerequisite: Homebrew must already be installed before you run `./init-system.sh`.

Official Homebrew installation docs:
- [brew.sh](https://brew.sh/)
- [Homebrew Installation](https://docs.brew.sh/Installation.html)

Current Homebrew installer command from `brew.sh`:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

User bootstrap, run as your normal account:

```bash
./init-user.sh
```

Optional wrapper:

```bash
./init.sh all
```

What each script does:
- `init-system.sh`: installs OS packages with `dnf` on Fedora or Homebrew on macOS, plus Docker and fonts where applicable
- `init-user.sh`: installs Rust if needed, installs `mise`, `starship`, only installs missing cargo tools, copies shell files, copies `dotfiles/` into `~/.config`, and creates `~/projects` plus `~/dependencies`
- `init.sh`: dispatches to `system`, `user`, or `all`

## neovim
The repo now includes a LazyVim configuration in `dotfiles/nvim` with the Catppuccin Mocha theme.

Bootstrap notes:
- `init-system.sh` installs `neovim` on Fedora and macOS
- `init-user.sh` copies the Neovim config into `~/.config/nvim`
- the first `nvim` launch will bootstrap `lazy.nvim`, LazyVim, and the configured plugins

Useful first-run checks:
- run `:LazyHealth` after the first startup
- run `:checkhealth` if Neovim reports missing external tools

## shell files
- `.bashrc` loads shared config from `.shellrc`
- `.zshrc` loads the same shared config for macOS
- `.shellrc` contains portable aliases, PATH setup, `mise`, `starship`, `onefetch`, and `zellij`

## notes
- `init-user.sh` should not be run as root, because it writes into the current user's home directory.
- `init-system.sh` is intentionally separate so locked-down machines can still use the user bootstrap.
- On Fedora, `init-system.sh` should be run with `sudo`; on macOS it should be run as the normal user because Homebrew does not support root-driven installs.
- The old `homebrew/cask-fonts` tap is no longer needed; `font-fira-code-nerd-font` now installs directly from the main Homebrew cask repository.
- Docker installation is attempted on both platforms, but Docker Desktop on macOS still needs to be launched once manually.
- The Fedora user bootstrap installs the FiraCode Nerd Font into the user's home directory and skips the download on reruns if the font is already present.

## alacritty
If you want to build Alacritty manually instead of installing it another way:

```bash
cd ~/dependencies

git clone https://github.com/alacritty/alacritty.git
cd alacritty

if [[ "$(uname -s)" == "Darwin" ]]; then
  cargo build --release
  cp target/release/alacritty /usr/local/bin
else
  cargo build --release --no-default-features --features=wayland
  cp target/release/alacritty /usr/local/bin
  cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
  desktop-file-install extra/linux/Alacritty.desktop
  update-desktop-database
fi
```
