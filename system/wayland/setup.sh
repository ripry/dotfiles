#!/usr/bin/bash

# OS: CachyOS
# niri + Noctalia v5 as a Wayland session alongside GNOME.
# fcitx5 is shared with GNOME (system/setup.sh) -- not installed/removed here.

set -euo pipefail

SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

sudo pacman -S --needed \
  niri \
  xwayland-satellite \
  noctalia

for rel_conf_path in $(cd "${SCRIPT_DIR}/config" && find niri noctalia -type f); do
  src="${SCRIPT_DIR}/config/${rel_conf_path}"
  dest="${CONFIG_HOME}/${rel_conf_path}"
  mkdir -p "$(dirname "${dest}")"
  ln -sf "${src}" "${dest}"
done

echo "Done. Log out and pick 'niri' at the GDM login screen."
