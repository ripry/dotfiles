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


# Shorten the post-resume lid-switch holdoff. Don't `systemctl restart
# systemd-logind` here -- kills niri's DRM master under a live session.
sudo mkdir -p /etc/systemd/logind.conf.d
sudo install -m 644 ${SCRIPT_DIR}/config-root/systemd/logind.conf.d/holdoff.conf /etc/systemd/logind.conf.d/
echo "Reboot required for the new HoldoffTimeoutSec to take effect."


# Patch niri-session's deprecated import-environment call on every niri
# (re)install, until https://github.com/niri-wm/niri/pull/3572 merges.
sudo install -m 755 ${SCRIPT_DIR}/config-root/local/bin/patch-niri-session /usr/local/bin/
sudo install -m 644 ${SCRIPT_DIR}/config-root/pacman.d/hooks/niri-import-environment-patch.hook /etc/pacman.d/hooks/
sudo /usr/local/bin/patch-niri-session


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


# Install mise
sudo pacman -S --needed mise
