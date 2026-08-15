#!/usr/bin/bash

# OS: CachyOS
# niri + Noctalia v5 as a Wayland session, with noctalia-greeter (greetd)
# as the login manager.
# fcitx5 is shared with GNOME (system/setup.sh) -- not installed/removed here.

set -euo pipefail

SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

sudo pacman -S --needed \
  niri \
  xwayland-satellite \
  noctalia \
  noctalia-greeter

for rel_conf_path in $(cd "${SCRIPT_DIR}/config" && find niri noctalia -type f); do
  src="${SCRIPT_DIR}/config/${rel_conf_path}"
  dest="${CONFIG_HOME}/${rel_conf_path}"
  mkdir -p "$(dirname "${dest}")"
  ln -sf "${src}" "${dest}"
done

# greetd runs as root and can follow a symlink into $HOME. The greeter
# runs as the "greeter" user, which can't traverse a 0700 home, so its
# config has to be a real copy -- re-run this script after editing it.
sudo mkdir -p /etc/greetd /var/lib/noctalia-greeter
sudo ln -sf "${SCRIPT_DIR}/config-root/greetd/config.toml" /etc/greetd/config.toml
sudo install -o greeter -g greeter -m 644 \
  "${SCRIPT_DIR}/config-root/noctalia-greeter/greeter.toml" \
  /var/lib/noctalia-greeter/greeter.toml

# Only one display manager may be enabled.
sudo systemctl disable gdm
sudo systemctl enable greetd

echo "Done. Reboot to land on the noctalia-greeter login screen."
