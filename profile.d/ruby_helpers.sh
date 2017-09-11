#!/usr/bin/env bash

brak() {
  for required_file in Gemfile Rakefile; do
    if [[ ! -f ${required_file} ]]; then
      echo -e "error: ${required_file} not found; aborting" >&2
      return 1
    fi
  done

  if ! command -v bundler >/dev/null 2>&1; then
    echo -e "error: \`bundler' not found in ${PATH}; aborting" >&2
    return 1
  fi

  bundle exec rake "${@}"
  return $?
}
