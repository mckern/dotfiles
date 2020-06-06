#!/usr/bin/env bash

if type -P dig &> /dev/null; then
  # Return MX records for a given domain
  mx() {
    [[ ${1:-UNSET} == "UNSET" ]] && return 1
    dig +short mx "${1}" | sort | tr "[:upper:]" "[:lower:]"
  }

  # return nameservers for a given domain
  nameservers() {
    [[ ${1:-UNSET} == "UNSET" ]] && return 1
    dig +short ns "${1}" | sort | tr "[:upper:]" "[:lower:]"
  }
fi
