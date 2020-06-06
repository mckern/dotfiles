#!/usr/bin/env bash

command_exists() {
  local cmd
  cmd="${1}"
  command -v "${cmd}" &> /dev/null
}

sha256sum() {
  local file
  file="${1}"

  if command_exists shasum; then
    command shasum --algorithm 256 "${file}"
  elif command_exists gsha256sum; then
    command gsha256sum "${file}"
  elif command_exists sha256sum; then
    command sha256sum "${file}"
  fi
}

# install
# diff (everything)
# diff (individual/detailed)
# check
# test?

while read -r file; do
  if [[ ${file} =~ ^\.|README|LICENSE|Brewfile|Aptfile|RPMfile|.gitkeep|$(basename "${0}") ]]; then
    continue
  fi

  if [[ -f "${HOME}/.${file}" ]]; then
    repo_sum="$(sha256sum "${file}" | awk '{print $1}')"
    installed_sum="$(sha256sum "${HOME}/.${file}" | awk '{print $1}')"
    if [[ ${repo_sum} != "${installed_sum}"   ]]; then
      echo "> ${file} differs from ~/.${file}"
      echo ">        local: ${repo_sum}"
      echo -e "> installed: ${installed_sum}\\n"
    fi
  else
    echo -e "> ${HOME}/.${file} not found\\n" 1>&2
  fi
done < <(git ls-tree -r master --name-only)
