#!/usr/bin/bash

# OS: CachyOS
# labwc + Noctalia v5 as an alternative session alongside GNOME.
# fcitx5 is shared with GNOME (system/setup.sh) -- not installed/removed here.

set -euo pipefail

SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

sudo pacman -S --needed \
  labwc \
  noctalia \
  xdg-desktop-portal-wlr \
  wdisplays \
  kanshi \
  wlr-randr \
  acpid \
  wlopm

for rel_conf_path in $(cd "${SCRIPT_DIR}/config" && find labwc kanshi noctalia -type f); do
  src="${SCRIPT_DIR}/config/${rel_conf_path}"
  dest="${CONFIG_HOME}/${rel_conf_path}"
  mkdir -p "$(dirname "${dest}")"
  ln -sf "${src}" "${dest}"
done

sudo mkdir -p /etc/acpi/events
sudo ln -sf "${SCRIPT_DIR}/config/acpi/lid-handler.sh" /etc/acpi/lid-handler.sh
sudo ln -sf "${SCRIPT_DIR}/config/acpi/events/lidswitch" /etc/acpi/events/lidswitch
sudo systemctl enable --now acpid.service

echo "Done. Log out and pick 'labwc' at the GDM login screen to try it."
