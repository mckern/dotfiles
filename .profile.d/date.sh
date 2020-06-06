#!/usr/bin/env bash

epoch() {
  if [[ ${1:-UNSET} == "UNSET" ]]; then
    date '+%s'
  else
    /usr/bin/ruby -rdate -e "puts Date.parse('${1}').strftime('%s')"
  fi
}
