# Cache the result of `mise activate` when binary is updated.
MISE_ACTIVATE_CACHE="${CACHE_HOME}/mise/activate.zsh"
MISE_BINARY="$(which mise)"

if [[ ! -r ${MISE_ACTIVATE_CACHE} || ${MISE_BINARY} -nt ${MISE_ACTIVATE_CACHE} ]]; then
  mkdir -p $(dirname ${MISE_ACTIVATE_CACHE})
  mise activate zsh > ${MISE_ACTIVATE_CACHE}
  zcompile ${MISE_ACTIVATE_CACHE}
fi
source ${MISE_ACTIVATE_CACHE}

unset MISE_ACTIVATE_CACHE MISE_BINARY
