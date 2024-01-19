zmodload zsh/zprof

source ${ZDOTDIR}/scripts/optimize-builtin-source.zsh
source ${ZDOTDIR}/scripts/set-base-directory.zsh

source ${ZDOTDIR}/scripts/init-homebrew.zsh
source ${ZDOTDIR}/scripts/run-sheldon-source-with-cache.zsh

zsh-defer source ${ZDOTDIR}/scripts/init-mise.zsh
zsh-defer source ${ZDOTDIR}/scripts/run-compinit-faster.zsh

zsh-defer source ${ZDOTDIR}/scripts/unset-base-directory.zsh
zsh-defer source ${ZDOTDIR}/scripts/reset-optimized-source.zsh
