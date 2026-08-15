#!/usr/bin/bash

# Undo everything set up by setup.sh in this directory.
# Safe to run from within GNOME. fcitx5 is intentionally left alone --
# it's shared with the GNOME session (see setup.sh).

set -euo pipefail

CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

pkill -x noctalia 2>/dev/null || true

rm -rf "${CONFIG_HOME}/niri" "${CONFIG_HOME}/noctalia"
rm -rf "${HOME}/.local/state/noctalia" "${HOME}/.cache/noctalia"

sudo pacman -Rns \
  niri \
  xwayland-satellite \
  noctalia

echo "Done. 'niri' will no longer appear as a GDM session option."
