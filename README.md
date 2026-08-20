# dotfiles

Provisioned declaratively by [`mise bootstrap`](https://mise.jdx.dev/bootstrap.html).
One branch covers every machine; OS differences live in separate config files.

## Profiles

**Linux**

| | |
| --- | --- |
| OS | [CachyOS](https://cachyos.org/) (Arch-based) |
| Packages | pacman, yay |
| Compositor | [niri](https://github.com/YaLTeR/niri) (scrollable-tiling Wayland) |
| Shell | [Noctalia](https://github.com/noctalia-dev/noctalia-shell), on greetd |

**macOS**

| | |
| --- | --- |
| OS | Tahoe |
| Packages | Homebrew |

## Setup

```sh
curl https://mise.run | sh
git clone <this repo> ~/dotfiles && cd ~/dotfiles
mise bootstrap
```

## Layout

| Path | What it holds |
| --- | --- |
| `mise.toml` | Portable half: CLI tools, and the sources under `cli/` |
| `mise.linux.toml` | CachyOS workstation: pacman/AUR packages, `/etc`, services, niri session |
| `mise.macos.toml` | macOS workstation: brew/cask, login shell, mac-only configs |
| `.miserc.toml` | Enables `auto_env`, which loads the two files above by platform |
| `cli/` | Config sources wanted on any machine |
| `linux/home/`, `macos/home/` | Config sources deployed under `~` |
| `linux/root/` | Config sources deployed under `/`, mirroring their target paths |
| `plugins/aur/` | Package plugin that teaches `mise bootstrap` the `aur:` manager |

The three `mise*.toml` files sit at the top level because mise picks the
platform config by filename.

## Everyday use

```sh
mise bootstrap --dry-run     # show every pending change
mise bootstrap               # converge the machine
mise bootstrap dotfiles status
mise bootstrap packages status
```

Every step is idempotent -- anything already in its desired state is skipped.

In a DevContainer, set `MISE_AUTO_ENV=false` to apply only the portable half.

## What stays imperative

mise can't template `$USER` into `[bootstrap.users]`, and the greetd PAM stack
is order-sensitive in a way `[dotfiles]` block entries can't express, so those
run as tasks (`mise run groups`, `mise run pam-keyring`) wired into
`[bootstrap.hooks]`.
