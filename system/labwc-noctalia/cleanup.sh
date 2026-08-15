#!/usr/bin/bash

# Undo everything set up by setup.sh in this directory.
# Safe to run from within GNOME. fcitx5 is intentionally left alone --
# it's shared with the GNOME session (see setup.sh).

set -euo pipefail

CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

pkill -x kanshi 2>/dev/null || true
pkill -x noctalia 2>/dev/null || true

rm -rf "${CONFIG_HOME}/labwc" "${CONFIG_HOME}/kanshi" "${CONFIG_HOME}/noctalia"
rm -rf "${HOME}/.local/state/noctalia" "${HOME}/.cache/noctalia"

sudo systemctl disable --now acpid.service 2>/dev/null || true
sudo rm -f /etc/acpi/lid-handler.sh /etc/acpi/events/lidswitch

sudo pacman -Rns \
  labwc \
  noctalia \
  xdg-desktop-portal-wlr \
  wdisplays \
  kanshi \
  wlr-randr \
  acpid \
  wlopm

echo "Done. 'labwc' will no longer appear as a GDM session option."
