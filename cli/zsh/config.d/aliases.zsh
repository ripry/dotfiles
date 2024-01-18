# Replace major tools
alias vi='nvim'
alias vim='nvim'
alias cat='bat --paging=never'
alias ls='eza --icons --header --git --ignore-glob=.git'


# Shorthands
alias c='clear'
alias pp='popd'

alias ll='ls --long'
alias la='ls --long --all'
alias lt='ls --long --all --tree'

alias resh='exec $SHELL -l'
alias zshrc='${EDITOR} ${ZDOTDIR:-$HOME}/.zshrc'
