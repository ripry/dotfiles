#!/usr/bin/bash

# OS: macOS

SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}

symlink_configs() {
  local conf_dirname=$1
  local symlink_src=${SCRIPT_DIR}/${conf_dirname}
  local symlink_dest=${CONFIG_HOME}/${conf_dirname}

  mkdir -p ${symlink_dest}

  for conf_path in `gfind ${symlink_src} -maxdepth 1 -type f`; do
    ln -s ${conf_path} ${symlink_dest}/$(basename ${conf_path})
  done
}

# Setup Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"


# Install GNU find
brew install findutils


# Setup terminal
brew install --cask wezterm
symlink_configs wezterm


# Install fonts for Japanese
brew tap homebrew/cask-fonts
brew install --cask font-hackgen-nerd


# Install browser
brew install --cask vivaldi


# Install editor
brew install --cask visual-studio-code-bin


# Setup docker
softwareupdate --install-rosetta --agree-to-license
brew install --cask rancher


# Install tools
brew install --cask \
  karabiner-elements \
  rectangle \
  scroll-reverser


# Install HotKey App from App Store
