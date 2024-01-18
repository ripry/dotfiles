#!/usr/bin/bash

# Package Manager: Homebrew

SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}
ZDOTDIR=${CONFIG_HOME}/zsh

mkdir -p ${ZDOTDIR}
ln -s ${SCRIPT_DIR}/.zshenv ~/.zshenv
ln -s ${SCRIPT_DIR}/zsh/.zshenv ${ZDOTDIR}/.zshenv
ln -s ${SCRIPT_DIR}/zsh/.zprofile ${ZDOTDIR}/.zprofile
ln -s ${SCRIPT_DIR}/zsh/.zshrc ${ZDOTDIR}/.zshrc
ln -s $(readlink -f zsh/config.d) ${ZDOTDIR}/config.d

brew install sheldon
ln -s ${SCRIPT_DIR}/sheldon/plugins.toml ${CONFIG_HOME}/sheldon/plugins.toml

brew install \
  starship mise gh \
  fzf jq neovim \
  bat bottom dust eza fd ripgrep

source ~/.zshenv ${ZDOTDIR}/.zshrc
