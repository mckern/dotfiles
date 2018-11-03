#!/usr/bin/env bash

# install
# diff (everything)
# diff (individual/detailed)
# check
# test?

git ls-tree -r master --name-only | while read -r file; do
  if [[ ${file} =~ ^\. ]] ||
     [[ ${file} =~ ^README ]] ||
     [[ ${file} =~ ^LICENSE ]] ||
     [[ ${file} =~ .gitkeep ]] ||
     [[ ${file} == $(basename "${0}") ]]; then
    continue
  fi

  if [[ -f "${HOME}/.${file}" ]]; then
    repo_sum="$(sha256sum "${file}" | awk '{print $1}')"
    installed_sum="$(sha256sum "${HOME}/.${file}" | awk '{print $1}')"
    if [[ "${repo_sum}" != "${installed_sum}" ]]; then
      echo "> ${file} differs from ~/.${file}"
      echo "> local: ${repo_sum}"
      echo -e "> installed: ${installed_sum}\\n"
    fi
  else
    echo "${HOME}/.${file} not found" 1>&2
  fi
done
