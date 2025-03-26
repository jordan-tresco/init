dnf -y install cmake freetype-devel fontconfig-devel libxcb-devel libxkbcommon-devel g++ openssl-devel sqlite-devel python3-tkinter ncurses-devel perl helix
dnf -y group install "Development Tools"

dnf copr enable varlad/onefetch
dnf -y install onefetch

# rust and rust packages
if ! cargo --version; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

cargo install zellij bottom rtx-cli bat exa ripgrep

cp -a ./dotfiles/. ~/.config

bat cache --build
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo

dnf -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

curl https://mise.run | sh
echo "eval \"\$(/home/jordan/.local/bin/mise activate bash)\"" >> ~/.bashrc
eval "$(mise activate bash)"

curl -sS https://starship.rs/install.sh | sh
echo "eval "$(starship init bash)"" >> ~/.bashrc
echo "zellij setup --generate-auto-start bash" >> ~/.bashrc

wget -P ~/Downloads https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraCode.zip
unzip ~/Downloads/FiraCode.zip

if [ ! -d "/usr/local/share/fonts/FiraCode" ]; then
  mkdir -p /usr/local/share/fonts/
  cp -r FiraCode /usr/local/share/fonts/
  chown -R root: /usr/local/share/fonts/FiraCode/
  chmod 644 /usr/local/share/fonts/FiraCode/*
  restorecon -vFr /usr/local/share/fonts/FiraCode/
  fc-cache -v
fi

mkdir ~/projects ~/dependencies

cd ~/projects
