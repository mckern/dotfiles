#!/usr/bin/env bash
# shellcheck disable=SC2139,SC2140

is_alias(){
  [[ "$(type "${1}")" == "${1} is aliased to \`g${1}'" ]]
}

gnu_bins=(
  "date"
  "dd"
  "df"
  "du"
  "ls"
  "md5sum"
  "sha1sum"
  "sha224sum"
  "sha256sum"
  "sha384sum"
  "sha512sum"
  "sort"
)

for bin in "${gnu_bins[@]}"; do
  if command -v "g${bin}" &>/dev/null; then
    alias "${bin}"="g${bin}"
  fi
done

if is_alias "ls"; then
  alias "ls"="gls --classify --color"
fi
