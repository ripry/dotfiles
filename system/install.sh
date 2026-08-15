#!/usr/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}

# config-root/ is root-owned and deployed by setup.sh; wayland/ by wayland/setup.sh.
for rel_conf_path in `cd ${SCRIPT_DIR}; find * -type f -not -name "*.sh" -not -path "config-root/*" -not -path "wayland/*"; exit;`; do
  src=${SCRIPT_DIR}/${rel_conf_path}
  dest=${CONFIG_HOME}/${rel_conf_path}

  mkdir -p $(dirname ${dest})
  ln -s ${src} ${dest}
done
