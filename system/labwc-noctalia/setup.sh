#!/usr/bin/bash

# OS: CachyOS
# Trying out labwc (wlroots compositor) + Noctalia v5 (shell) as an
# alternative session alongside the existing GNOME session.
# GDM will offer "labwc" as a session once the labwc package is installed
# (it ships /usr/share/wayland-sessions/labwc.desktop itself).
#
# NOTE: fcitx5 is NOT installed here -- it's already set up for GNOME via
# system/setup.sh and is shared between both sessions. Do not remove it
# in cleanup.sh.

set -euo pipefail

SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

# All packages below are in CachyOS's own repos (no AUR needed).
sudo pacman -S --needed \
  labwc \
  noctalia \
  xdg-desktop-portal-wlr \
  wdisplays \
  kanshi \
  wlr-randr \
  acpid \
  wlopm

# Config snapshot -> ~/.config (plain copy, not symlinked, so it can be
# hand-tweaked live without touching this repo).
mkdir -p "${CONFIG_HOME}/labwc" "${CONFIG_HOME}/kanshi" "${CONFIG_HOME}/noctalia"
cp "${SCRIPT_DIR}/config/labwc/"* "${CONFIG_HOME}/labwc/"
cp "${SCRIPT_DIR}/config/kanshi/config" "${CONFIG_HOME}/kanshi/config"
cp "${SCRIPT_DIR}/config/noctalia/config.toml" "${CONFIG_HOME}/noctalia/config.toml"

# acpid: toggle the internal panel on lid open/close (root-owned, so
# symlinked from this repo instead of copied -- edits here take effect
# immediately, no redeploy step).
sudo mkdir -p /etc/acpi/events
sudo ln -sf "${SCRIPT_DIR}/config/acpi/lid-handler.sh" /etc/acpi/lid-handler.sh
sudo ln -sf "${SCRIPT_DIR}/config/acpi/events/lidswitch" /etc/acpi/events/lidswitch
sudo systemctl enable --now acpid.service

echo "Done. Log out and pick 'labwc' at the GDM login screen to try it."
