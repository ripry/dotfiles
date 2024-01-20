#!/usr/bin/bash

# Package Manager: Homebrew

SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}

symlink_configs() {
  local conf_dirname=$1
  local symlink_src=${SCRIPT_DIR}/{$conf_dirname}
  local symlink_dest=${CONFIG_HOME}/{$conf_dirname}

  mkdir -p ${symlink_dest}

  for conf_path in `find maxdepth 1 ${symlink_src} -type f`; do
    ln -s ${conf_path} ${symlink_dest}/$(basename ${conf_path})
  done
}


ln -s ${SCRIPT_DIR}/.zshenv ~/.zshenv
symlink_configs zsh
symlink_configs zsh/config.d


brew install sheldon
symlink_configs sheldon

brew install \
  starship mise gh \
  fzf jq neovim \
  bat bottom dust eza fd ripgrep

if ! type git &>/dev/null; then
  brew install git
fi
symlink_configs git

source ~/.zshenv ${ZDOTDIR}/.zshrc
