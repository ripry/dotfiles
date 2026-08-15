#!/usr/bin/bash

# Runs as root via acpid on every lid button ACPI event (open AND close --
# acpid doesn't distinguish them in the event name, so we just re-check the
# current state). Toggles the internal panel for the logged-in graphical
# user, so closing the lid drops to external-monitor-only ("clamshell
# mode"). GNOME does this automatically via gsd-power; labwc has nothing
# equivalent, hence this script.
#
# acpid runs system-wide regardless of which session is active, so this
# fires under GNOME too -- skip there and let gsd-power handle it natively
# (wlr-randr doesn't speak Mutter's protocol anyway, this would just error).

if ! pgrep -x labwc >/dev/null; then
  exit 0
fi

STATE=$(awk '{print $2}' /proc/acpi/button/lid/*/state)
TARGET_USER=rikuyam
RUNTIME_DIR=/run/user/1000

if [ "${STATE}" = "closed" ]; then
  ACTION=off
else
  ACTION=on
fi

runuser -u "${TARGET_USER}" -- \
  env XDG_RUNTIME_DIR="${RUNTIME_DIR}" WAYLAND_DISPLAY=wayland-0 \
  wlr-randr --output eDP-1 --"${ACTION}"
