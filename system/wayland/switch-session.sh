#!/usr/bin/bash

# Log out of the current graphical session so GDM shows the login screen
# again. GDM/AccountsService already remembers your last-picked session
# per user, so there's no "target" to pass -- just log out here, then pick
# GNOME or niri at the login screen (whichever you didn't just leave).
#
# Investigated 2026-08-15: there's no meaningful GNOME daemon bloat to
# disable when running another session. GNOME's heavy stuff (gnome-shell,
# gsd-*, tracker, gnome-software, evolution-*) simply never starts outside
# a GNOME session already. What *does* run either way (gvfs, gnome-keyring,
# at-spi2, xdg-desktop-portal-gtk) is shared cross-desktop infra that
# niri/Noctalia also rely on (Wi-Fi/SSH secrets, trash/network mounts, GTK
# file picker, accessibility) -- turning those off would break things, not
# save anything meaningful.

set -euo pipefail

if [ -z "${XDG_SESSION_ID:-}" ]; then
  echo "XDG_SESSION_ID is not set -- are you in a graphical session?" >&2
  exit 1
fi

echo "Logging out of session ${XDG_SESSION_ID}..."
loginctl terminate-session "${XDG_SESSION_ID}"
