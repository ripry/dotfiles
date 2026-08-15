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

# GDM's PAM stack unlocks the login keyring with the password you just
# typed; greetd's doesn't, so the keyring stays locked and prompts after
# the desktop comes up. greetd uses this same file for the greeter's own
# session (there is no greetd-greeter file), and the greeter user has no
# keyring -- without the pam_succeed_if guard it logs an err-priority
# "couldn't unlock the login keyring", which shows up as red text on the
# console during the handoff to the compositor.
# Not symlinked from the repo on purpose -- a PAM file writable from $HOME
# is an auth bypass waiting to happen.
grep -q pam_gnome_keyring /etc/pam.d/greetd || sudo sed -i \
  -e '/^auth       include      system-local-login$/a auth       [success=1 default=ignore] pam_succeed_if.so quiet user = greeter\nauth       optional     pam_gnome_keyring.so' \
  -e '/^session    include      system-local-login$/a session    [success=1 default=ignore] pam_succeed_if.so quiet user = greeter\nsession    optional     pam_gnome_keyring.so auto_start' \
  /etc/pam.d/greetd

# Only one display manager may be enabled.
sudo systemctl disable gdm
sudo systemctl enable greetd

echo "Done. Reboot to land on the noctalia-greeter login screen."
