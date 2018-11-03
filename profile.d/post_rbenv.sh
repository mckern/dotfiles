#!/usr/bin/env bash

command -v rbenv &>/dev/null || return

if [[ -n "${COLORS_DEFINED}" ]]; then
  if [[ -f ~/.profile.d/pre_colors.sh ]]; then
    # shellcheck source=/dev/null
    source ~/.profile.d/pre_colors.sh
  fi
fi

declare -x CONFIGURE_OPTS
declare -x MAKE_OPTS
declare -x RBENV_ENABLED
declare -x RBENV_ROOT
declare -x RUBY_CONFIGURE_OPTS

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

enable_rvm(){
  [[ -n "${RBENV_ENABLED}" ]] && return

  RBENV_ROOT="$(brew --prefix)/var/rbenv"
  # shellcheck disable=SC2089
  CONFIGURE_OPTS=" --with-readline-dir='$(brew --prefix readline)'"
  # shellcheck disable=SC2089
  CONFIGURE_OPTS+=" --with-openssl-dir='$(brew --prefix openssl)'"
  RUBY_CONFIGURE_OPTS="--without-tcl --without-tk --enable-shared --disable-install-doc"
  MAKE_OPTS="-j$(cpu_core_count)"

  eval "$(command rbenv init - --no-rehash)"
}

rbenv(){
  if [[ -z "${RBENV_ENABLED}" ]]; then
    echo -e "${txtdim}> rbenv is initializing...${txtrst}"
    enable_rvm
  fi
  command rbenv "${@}"
}
