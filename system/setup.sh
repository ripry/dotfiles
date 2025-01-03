#!/usr/bin/bash

# OS: EndeavourOS
# DE: GNOME

SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}

symlink_configs() {
  local conf_dirname=$1
  local symlink_src=${SCRIPT_DIR}/${conf_dirname}
  local symlink_dest=${CONFIG_HOME}/${conf_dirname}

  mkdir -p ${symlink_dest}

  for conf_path in `find ${symlink_src} -maxdepth 1 -type f`; do
    ln -s ${conf_path} ${symlink_dest}/$(basename ${conf_path})
  done
}

symlink_configs environment.d
symlink_configs sysmemd/user
symlink_configs xremap
symlink_configs alacritty
symlink_configs tmux


sudo systemctl enable --now bluetooth.service


yay -S thermald
sudo systemctl enable --now thermald.service


# Setup browser connector for GNOME Shell extensions
yay -S gnome-browser-connector

# Fix broken dark theme of libadwaita
yay -S xdg-desktop-portal-gnome

# Setup key remapper
# ref: https://extensions.gnome.org/extension/5060/xremap/
yay -S xremap-gnome-bin

# Run xremap without sudo
# ref: https://github.com/k0kubun/xremap#running-xremap-without-sudo
sudo gpasswd -a ${USER} input
echo "uinput" | sudo tee -a /etc/modules-load.d/uinput.conf
echo 'KERNEL=="uinput", GROUP="input", MODE="0660"' | sudo tee /etc/udev/rules.d/99-input.rules

# Autostart xremap with systemd
sysmemd --user enable --now xremap.service


# Setup input method
yay -S fcitx5 fcitx5-gtk fcitx5-mozc

# Autostart fcitx5 with XDG Autostart
sudo mkdir -p /etc/xdg/autostart
sudo cp /usr/share/applications/org.fcitx.Fcitx5.desktop /etc/xdg/autostart

# ref: https://extensions.gnome.org/extension/261/kimpanel/


# Install fonts for Japanese
yay -S noto-fonts-emoji noto-fonts-cjk ttf-hackgen


# Install browser
yay -S vivaldi vivaldi-ffmpeg-codecs vivaldi-widevine


# Install editor
yay -S visual-studio-code-bin cursor-bin


# Setup terminal
yay -S alacritty tmux tmux-pluin-manager


# Install Windows app runner
yay -S wine winetricks wine-gecko wine-mono lib32-gnutls


# Setup docker
yay -S docker docker-compose docker-buildx
# ref: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
sudo groupadd docker; sudo usermod -aG docker $USER; newgrp docker
systemctl enable --now docker.service


# Setup zsh as default
yay -S zsh
chsh -s $(which zsh)

# Setup Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
