#!/usr/bin/env bash

cpu_core_count(){
  if command -v nproc &>/dev/null; then
    nproc
  elif command -v sysctl &>/dev/null; then
    sysctl -n hw.ncpu
  elif [[ -f /proc/cpuinfo ]]; then
    grep -c 'processor' /proc/cpuinfo
  else
    echo 1
  fi
  return $?
}

if command -v rbenv &>/dev/null; then
  RBENV_ROOT="$(brew --prefix)/var/rbenv"
  # shellcheck disable=SC2089
  CONFIGURE_OPTS=" --with-readline-dir='$(brew --prefix readline)'"
  # shellcheck disable=SC2089
  CONFIGURE_OPTS+=" --with-openssl-dir='$(brew --prefix openssl)'"
  RUBY_CONFIGURE_OPTS="--without-tcl --without-tk --enable-shared --disable-install-doc"
  MAKE_OPTS="-j$(cpu_core_count)"

  # shellcheck disable=2090
  export RBENV_ROOT CONFIGURE_OPTS RUBY_CONFIGURE_OPTS MAKE_OPTS

  eval "$(rbenv init - --no-rehash)"
fi
