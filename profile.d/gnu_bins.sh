#!/usr/bin/env bash
# shellcheck disable=SC2139,SC2140

is_alias() {
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
  "xargs"
)

for bin in "${gnu_bins[@]}"; do
  if command -v "g${bin}" &> /dev/null; then
    alias "${bin}"="g${bin}"
  fi
done

if command -pv exa &> /dev/null; then
  alias "ls"="exa --classify --color=auto"
elif is_alias "ls"; then
  alias "ls"="gls --classify --color=auto"
fi

unset is_alias
