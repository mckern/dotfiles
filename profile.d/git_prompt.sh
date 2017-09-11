#!/usr/bin/env bash

# disable "var is referenced but not assigned" because
# these values are intended to be consumed by any other
# scripts that may change output color.
#   url: https://github.com/koalaman/shellcheck/wiki/SC2154
# shellcheck disable=2154
: "shellcheck disable=2154"

declare scm_branch
declare flat_prompt
flat_prompt="${PS1}"

###### Git functions ######

git_test_directory(){
  git rev-parse --git-dir &> /dev/null
  return $?
}

git_branch_name() {
  local branch
  branch="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"

  if [[ ${branch} == "HEAD" ]]; then
    branch='detached*'
  fi

  echo "(git:${branch})"
  return 0
}

git_test_dirty_branch() {
  local status
  status="$(git status --porcelain 2> /dev/null)"

  if [[ -n ${status} ]]; then
    return 0
  fi
  return 1
}

toggle_git_prompt(){
  scm_branch="$(git_branch_name)"

  if git_test_dirty_branch; then
    set_dirty_scm_prompt
    return 0
  else
    set_scm_prompt
    return 0
  fi
  return 1
}

###### HG functions ######

hg_test_directory(){
  hg root &> /dev/null
  return $?
}

hg_branch_name() {
  local branch
  branch="$(hg id --branch 2> /dev/null)"

  echo "(hg:${branch})"
  return 0
}

hg_test_dirty_branch() {
  local status
  status="$(hg status 2> /dev/null)"

  if [[ -n ${status} ]]; then
    return 0
  fi
  return 1
}

toggle_hg_prompt(){
  scm_branch="$(hg_branch_name)"

  if hg_test_dirty_branch; then
    set_dirty_scm_prompt
    return 0
  else
    set_scm_prompt
    return 0
  fi
  return 1
}

###### Generic functions

set_flat_prompt(){
  export PS1="${flat_prompt}"
}

set_scm_prompt(){
  export PS1="\[${bldgrn}\]\u@\h \[${bldblu}\]\W \[${bldcyn}\]\${scm_branch} \[${bldblu}\]\$\[${txtrst}\] "
}

set_dirty_scm_prompt(){
  export PS1="\[${bldgrn}\]\u@\h \[${bldblu}\]\W \[${bldred}\]\${scm_branch} \[${bldblu}\]\$\[${txtrst}\] "
}

toggle_prompt(){
  if git_test_directory; then
    toggle_git_prompt
    return 0
  fi

  if hg_test_directory; then
    toggle_hg_prompt
    return 0
  fi

  set_flat_prompt
  return 0
}

export PROMPT_COMMAND="toggle_prompt; ${PROMPT_COMMAND}"
