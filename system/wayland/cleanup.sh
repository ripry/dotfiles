#!/usr/bin/bash

# Undo everything set up by setup.sh in this directory, back to GDM + GNOME.
# fcitx5 is intentionally left alone -- it's shared with the GNOME session
# (see system/setup.sh).

set -euo pipefail

CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

pkill -x noctalia 2>/dev/null || true

rm -rf "${CONFIG_HOME}/niri" "${CONFIG_HOME}/noctalia"
rm -rf "${HOME}/.local/state/noctalia" "${HOME}/.cache/noctalia"

# Restore GDM before removing greetd, so a graphical login always exists.
sudo systemctl disable --now greetd
sudo systemctl enable gdm
sudo rm -f /etc/greetd/config.toml /var/lib/noctalia-greeter/greeter.toml

sudo pacman -Rns \
  niri \
  xwayland-satellite \
  noctalia \
  noctalia-greeter

echo "Done. Reboot to land back on GDM."
