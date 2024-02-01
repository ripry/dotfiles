# zmodload zsh/zprof

# ---
# Prepare utils
# ---
# Run `source` with zcompile
source-with-zcompile() {
  zcompile-if-not-compiled $@
  builtin source $@
}
zcompile-if-not-compiled() {
  local source=
  for source in "$@"; do
    local compiled=${source}.zwc
    if [[ ! -r ${compiled} || ${source} -nt ${compiled} ]]; then
      zcompile $1
    fi
  done
}

# Run `eval "$(generate-script)"` with cache
eval-script-with-cache() {
  local gen_script=$1
  local watching_path=$2 # config or binary
  local cache_path=${CACHE_HOME}/eval-script/${gen_script}.zsh

  if [[ ! -r ${cache_path} || ${watching_path} -nt ${cache_path} ]]; then
    mkdir -p $(dirname ${cache_path})
    eval ${gen_script} > ${cache_path}
    zcompile ${cache_path}
  fi

  source ${cache_path}
}


# ---
# Start initializations
# ---
# Init Homebrew
export HOMEBREW_PREFIX="/opt/homebrew"
eval-script-with-cache \
  "${HOMEBREW_PREFIX}/bin/brew shellenv zsh" \
  "${HOMEBREW_PREFIX}/bin/brew"
FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"

# Setup plugins with sheldon
eval-script-with-cache \
  "sheldon --quiet source" \
  "${CONFIG_HOME}/sheldon/plugins.toml"

# Optimize next startup
zsh-defer zcompile-if-not-compiled ${ZDOTDIR}/.zprofile ${ZDOTDIR}/.zshenv ${ZDOTDIR}/.zshrc


# ---
# Show zsh startup profiles if zprof loaded
# ---
if type zprof &>/dev/null; then; zprof; fi;
