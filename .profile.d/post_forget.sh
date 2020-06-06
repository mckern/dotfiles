#!/usr/bin/env bash

export HISTIGNORE="${HISTIGNORE}:forget*"

forget() {
  if [[ ${#} == 0 ]]; then
    ( 
      __histfile="$(mktemp)"
      PROMPT_COMMAND='' \
        HISTFILE="${__histfile}" \
        PS1='\[\033[01;35m\](forgetful) \u@\h \[\033[01;34m\]\W \$ \[\033[00m\]' \
        FORGETFUL="true" \
        bash
      rm "${__histfile}"
    )
  else
    eval "${@}"
  fi
  return "${?}"
}
