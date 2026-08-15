#!/usr/bin/bash

# OS: CachyOS
# DE: niri + Noctalia (see wayland/setup.sh)

SCRIPT_DIR=$(cd $(dirname $0); pwd)

# Install config
sh install.sh


# Install AUR helper
sudo pacman -S yay

# Refresh Fontconfig cache
fc-cache -f -v


# Install thermal deamon
yay -S thermald
sudo systemctl enable --now thermald.service


# Cap battery charging at 80%
sudo install -m 644 ${SCRIPT_DIR}/config-root/udev/rules.d/99-battery-charge-threshold.rules /etc/udev/rules.d/
sudo udevadm control --reload && sudo udevadm trigger --subsystem-match=power_supply


# Setup key remapper
# The -gnome build has no deps and works fine under niri; only its
# application-detection path is GNOME-specific, which config.yaml doesn't use.
yay -S xremap-gnome-bin

# Run xremap without sudo
# ref: https://github.com/k0kubun/xremap#running-xremap-without-sudo
sudo gpasswd -a ${USER} input
echo "uinput" | sudo tee -a /etc/modules-load.d/uinput.conf
echo 'KERNEL=="uinput", GROUP="input", MODE="0660"' | sudo tee /etc/udev/rules.d/99-input.rules

# Autostart xremap with systemd
systemctl --user enable --now xremap.service


# Setup input method
yay -S fcitx5 fcitx5-mozc fcitx5-config-qt


# Install fonts for Japanese
yay -S noto-fonts-emoji noto-fonts-cjk ttf-hackgen


# Install browser
yay -S vivaldi vivaldi-ffmpeg-codecs vivaldi-widevine


# Install editor
yay -S visual-studio-code-bin cursor-bin


# Setup terminal
yay -S alacritty tmux tmux-plugin-manager


# Setup docker
yay -S docker docker-compose docker-buildx
# ref: https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user
sudo groupadd docker; sudo usermod -aG docker $USER; newgrp docker
sudo systemctl enable --now docker.service


# Setup zsh as default
yay -S zsh
chsh -s $(which zsh)


# Setup Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
