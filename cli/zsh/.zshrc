# zmodload zsh/zprof

source ${ZDOTDIR}/scripts/set-base-directory.zsh

source ${ZDOTDIR}/scripts/prepare-source-optimization.zsh
source ${ZDOTDIR}/scripts/prepare-eval-optimization.zsh
zcompile_if_not_compiled ${ZDOTDIR}/.zshrc

# Init Homebrew
export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"
eval_script_with_cache \
  "${HOMEBREW_PREFIX}/bin/brew shellenv zsh" \
  "${CACHE_HOME}/homebrew/shellenv.zsh" \
  "${HOMEBREW_PREFIX}/bin/brew"
FPATH="${HOMEBREW_PREFIX}/share/zsh/site-functions:${FPATH}"

# Setup plugins with sheldon
eval_script_with_cache \
  "sheldon source" \
  "${CACHE_HOME}/sheldon/source.zsh" \
  "${CONFIG_HOME}/sheldon/plugins.toml"

# Init mise
zsh-defer eval_script_with_cache \
  "mise activate zsh" \
  "${CACHE_HOME}/mise/activate.zsh" \
  "$(which mise)"

zsh-defer source ${ZDOTDIR}/scripts/run-compinit-faster.zsh

zsh-defer source ${ZDOTDIR}/scripts/unset-base-directory.zsh

if type zprof &>/dev/null ;then
  zprof
fi
