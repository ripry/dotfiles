#!/usr/bin/bash

# Package Manager: mise

# Install config
sh install.sh


# Install tools
mise install


# Reload shell config
source ${HOME}/.zshenv ${ZDOTDIR}/.zshrc
