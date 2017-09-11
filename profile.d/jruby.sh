#!/usr/bin/env bash

case "$(uname -s)" in
  Linux* )
    __heap="$(vmstat --stats --unit K | grep "total memory" | sed -e 's/^[ \t]*//' | cut -f1 -d' ')"
    __heap="$(( __heap / 1024 / 8 ))"
  ;;
  Darwin* )
    __heap="$(( $(sysctl -n hw.memsize) / 1024 / 1024 / 8 ))"
  ;;
esac

__jruby_options=(
  "-J-XX:+CMSClassUnloadingEnabled"
  "-J-XX:+UseConcMarkSweepGC"
  "-J-Xmx${__heap}m"
  "-J-server"
)

export JRUBY_OPTS="${__jruby_options[*]}"
unset __jruby_options
unset __threshold
unset __heap
