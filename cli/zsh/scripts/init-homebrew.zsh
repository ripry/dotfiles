BREW_PREFIX="/home/linuxbrew/.linuxbrew"

eval "$(${BREW_PREFIX}/bin/brew shellenv)"
FPATH="${BREW_PREFIX}/share/zsh/site-functions:${FPATH}"

unset BREW_PREFIX
