#!/usr/bin/env bash

find . -maxdepth 1 | while read -r file; do
  name="$(basename "${file}")"
  if [[ ${name} =~ ^\. ]] ||
     [[ ${name} =~ ^README ]] ||
     [[ ${name} =~ ^LICENSE ]] ||
     [[ ${name} == $(basename "${0}") ]]; then
    continue
  fi

  if [[ -f ${file} ]]; then
    if [[ $(sha256sum "${file}") != $(sha256sum "${HOME}/.${name}") ]]; then
      echo "${name} differs from ~/.${name}"
    fi
  fi
done
