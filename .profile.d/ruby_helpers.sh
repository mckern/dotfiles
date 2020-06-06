#!/usr/bin/env bash

bundle_wrapper() {
  for required_file in Gemfile Rakefile; do
    if [[ ! -f ${required_file} ]]; then
      echo -e "error: ${required_file} not found; aborting" >&2
      return 1
    fi
  done

  if ! command -v bundler > /dev/null 2>&1; then
    echo -e "error: \`bundler' not found in ${PATH}; aborting" >&2
    return 1
  fi
  return 0
}

brak() {
  bundle_wrapper || return 1

  bundle exec rake "${@}"
  return $?
}

berc() {
  bundle_wrapper || return 1

  bundle exec rubocop "${@}"
  return $?
}
