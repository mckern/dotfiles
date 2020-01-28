#!/usr/bin/env bash

paths() {
  xargs -n1 -d: <<<"${PATH}" | awk '!x[$0]++'
}

where() {
  if [[ -z "${1}" ]]; then
    echo "where() requires an argument" >&2
    return 1
  fi

  local name
  name="${1}"

  local executable_path

  while read -r path; do
    executable_path="${path}/${name}"

    if [[ -x "${executable_path}" ]]; then
      echo "${executable_path}"
    fi
  done < <(paths)
}
