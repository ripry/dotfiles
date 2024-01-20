# Run `eval "$(cmd generate-script)"` with cache
eval_script_with_cache() {
  local gen_script=$1
  local cache_path=$2
  local watching_path=$3 # config or binary

  if [[ ! -r ${cache_path} || ${watching_path} -nt ${cache_path} ]]; then
    mkdir -p $(dirname ${cache_path})
    eval ${gen_script} > ${cache_path}
    zcompile ${cache_path}
  fi

  source ${cache_path}
}
