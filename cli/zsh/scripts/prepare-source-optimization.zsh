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
