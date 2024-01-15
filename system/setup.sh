#!/usr/bin/bash

# OS: EndeavourOS
# DE: GNOME

SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}

symlink_conf() {
  conf_path="$1"
  origin_path="$SCRIPT_DIR/$conf_path"
  symlink_path="$CONFIG_HOME/$conf_path"

  if [ ! -e "$symlink_path" ]; then
    mkdir -p "$(dirname "$symlink_path")"
    ln -s $origin_path $symlink_path
    echo "[INFO] Config symlinked: $symlink_path"
  else
    echo "[ERROR] The specified config already exists: $symlink_path"
  fi
}


sudo systemctl enable --now bluetooth.service


yay -S thermald
sudo systemctl enable --now thermald.service


# Setup browser connector for GNOME Shell extensions
yay -S gnome-browser-connector


# Setup key remapper
# ref: https://extensions.gnome.org/extension/5060/xremap/
yay -S xremap-gnome-bin
symlink_conf xremap/config.yml

# Run xremap without sudo
# ref: https://github.com/k0kubun/xremap#running-xremap-without-sudo
sudo gpasswd -a ${USER} input
echo "uinput" | sudo tee -a /etc/modules-load.d/uinput.conf
echo 'KERNEL=="uinput", GROUP="input", MODE="0660"' | sudo tee /etc/udev/rules.d/99-input.rules

# Autostart xremap with systemd
symlink_conf sysmemd/user/xremap.service
sysmemd --user enable --now xremap.service


# Setup input method
yay -S fcitx5 fcitx5-gtk fcitx5-mozc
symlink_conf environment.d/im.conf

# Autostart fcitx5 with XDG Autostart
sudo mkdir -p /etc/xdg/autostart
sudo cp /usr/share/applications/org.fcitx.Fcitx5.desktop /etc/xdg/autostart

# ref: https://extensions.gnome.org/extension/261/kimpanel/


# Install fonts for Japanese
yay -S noto-fonts-emoji noto-fonts-cjk ttf-hackgen


# Install browser
yay -S vivaldi vivaldi-ffmpeg-codecs vivaldi-widevine


# Install editor
yay -S visual-studio-code-bin


# Setup terminal
yay -S wezterm
symlink_conf wezterm/wezterm.lua


# Install Windows app runner
yay -S wine winetricks wine-gecko wine-mono lib32-gnutls

# Setup zsh as default
yay -S zsh
chsh -s $(which zsh)

# Setup Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
