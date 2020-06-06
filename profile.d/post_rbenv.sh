#!/usr/bin/env bash

command -v rbenv &> /dev/null || return

declare CONFIGURE_OPTS
declare MAKE_OPTS
declare RBENV_ENABLED
declare RBENV_ROOT
declare RUBY_CONFIGURE_OPTS

export CONFIGURE_OPTS MAKE_OPTS RBENV_ENABLED RBENV_ROOT RUBY_CONFIGURE_OPTS

cpu_core_count() {
  if command -v nproc &> /dev/null; then
    nproc
  elif command -v sysctl &> /dev/null; then
    sysctl -n hw.ncpu
  elif [[ -f /proc/cpuinfo ]]; then
    grep -c 'processor' /proc/cpuinfo
  else
    echo 1
  fi
  return $?
}

enable_rvm() {
  [[ -n ${RBENV_ENABLED}   ]] && return

  RBENV_ROOT="$(brew --prefix)/var/rbenv"
  # shellcheck disable=SC2089
  CONFIGURE_OPTS=" --with-readline-dir='$(brew --prefix readline)'"
  # shellcheck disable=SC2089
  RUBY_CONFIGURE_OPTS="--without-tcl --without-tk --enable-shared --disable-install-doc"
  RUBY_CONFIGURE_OPTS=" --with-openssl-dir=$(brew --prefix openssl)"
  MAKE_OPTS="-j$(cpu_core_count)"

  eval "$(command rbenv init - --no-rehash)"
}

rbenv() {
  if [[ -z ${RBENV_ENABLED}   ]]; then
    echo -e "${txtdim}> rbenv is initializing...${txtrst}"
    enable_rvm
  fi
  command rbenv "${@}"
}
