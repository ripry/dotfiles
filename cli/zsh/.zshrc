# zmodload zsh/zprof

# ---
# Prepare utils
# ---
# Run `source` with zcompile
source_with_compile() {
  zcompile_if_not_compiled $1
  builtin source $1
}
zcompile_if_not_compiled() {
  local source=$1
  local compiled=${source}.zwc
  if [[ ! -r ${compiled} || ${source} -nt ${compiled} ]]; then
    zcompile $1
  fi
}

# Run `eval "$(cmd generate-script)"` with cache
eval_script_with_cache() {
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
zcompile_if_not_compiled ${ZDOTDIR}/.zshrc

# Init Homebrew
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
eval_script_with_cache \
  "${HOMEBREW_PREFIX}/bin/brew shellenv zsh" \
  "${HOMEBREW_PREFIX}/bin/brew"
FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"

# Setup plugins with sheldon
eval_script_with_cache \
  "sheldon --quiet source" \
  "${CONFIG_HOME}/sheldon/plugins.toml"


# ---
# Show zsh startup profiles if zprof loaded
# ---
if type zprof &>/dev/null; then; zprof; fi;
