#!/usr/bin/bash

# Package Manager: Homebrew

# Install config
sh install.sh


# Install tools
brew install sheldon

brew install \
  starship mise gh \
  fzf jq neovim \
  bat bottom dust eza fd ripgrep git-delta

if ! type git &>/dev/null; then
  brew install git
fi


# Reload shell config
source ${HOME}/.zshenv ${ZDOTDIR}/.zshrc
