#!/usr/bin/bash

# Undo everything set up by setup.sh in this directory.
#
# GNOME and GDM are gone, so this leaves the machine with NO graphical
# session -- you land on a TTY and have to install a compositor and a
# login manager yourself. Read that twice before running it.
#
# fcitx5 is intentionally left alone (installed by system/setup.sh).

set -euo pipefail

CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

read -rp "This removes the only graphical session on this machine. Continue? [y/N] " reply
[[ ${reply} == [yY] ]] || exit 1

pkill -x noctalia 2>/dev/null || true

rm -rf "${CONFIG_HOME}/niri" "${CONFIG_HOME}/noctalia"
rm -rf "${HOME}/.local/state/noctalia" "${HOME}/.cache/noctalia"

sudo systemctl disable --now greetd
sudo rm -f /etc/greetd/config.toml /var/lib/noctalia-greeter/greeter.toml

sudo pacman -Rns \
  niri \
  xwayland-satellite \
  noctalia \
  noctalia-greeter

echo "Done. There is no display manager left -- log in on a TTY after reboot."
