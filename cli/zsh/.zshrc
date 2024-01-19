# zmodload zsh/zprof

source ${ZDOTDIR}/scripts/set-base-directory.zsh

source ${ZDOTDIR}/scripts/prepare-source-optimization.zsh
zcompile_if_not_compiled ${ZDOTDIR}/.zshrc

source ${ZDOTDIR}/scripts/init-homebrew.zsh
source ${ZDOTDIR}/scripts/run-sheldon-source-with-cache.zsh

zsh-defer source ${ZDOTDIR}/scripts/init-mise.zsh
zsh-defer source ${ZDOTDIR}/scripts/run-compinit-faster.zsh

zsh-defer source ${ZDOTDIR}/scripts/unset-base-directory.zsh

if type zprof &>/dev/null ;then
  zprof
fi
