#!/usr/bin/env bash

# Set up handy aliases, simple environment tweaks, and other pleasantries.
# While shooting yourself in the foot is always a possibility, you may as well
# do it in comfort and occasionally style.

# Owner: Ryan McKern

# Start counting how long it takes to source this profile
__begin="$(date +"%s")"

# Keep so, so, so much history
export HISTFILESIZE=''
export HISTSIZE=''
# Don't keep duplicates in history; keep more history!
export HISTCONTROL="ignorespace:erasedups"
# Ignore backgrounding, mutt, quitting, and clearing
export HISTIGNORE="&:mutt:[bf]g:exit:clear"
# Append every command to history
PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND}"

# Avoid overwriting history
shopt -s histappend
# Smart handling of multi-line commands
shopt -s cmdhist
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Set the default umask to group-writable
umask 0022

# This is the minimum viable Bash version.
# Anything older than this will be used as the cut-off point.
__minimum_viable='3'

# Don't do anything for non-interactive shells
[[ -z "${PS1}"  ]] && return

# Set the old Gentoo default prompt if this isn't a dumb terminal
if [[ ${TERM} != 'dumb' ]] && [[ -n ${BASH} ]]; then
  if [[ ${UID} -eq "0" ]] ; then
    # Privileged prompt, ending in #
    export PS1='\[\033[01;31m\]\h \[\033[01;34m\]\W \$ \[\033[00m\]'
  else
    # Unprivileged prompt, ending in $
    export PS1='\[\033[01;32m\]\u@\h \[\033[01;34m\]\W \$ \[\033[00m\]'
  fi
fi

# Are we using something greater than bash 2?
if (( "${BASH_VERSINFO[0]}" < "${__minimum_viable}" )); then
  echo "You're using an old version of Bash (${BASH_VERSION}). Sourcing .bash_profile will now halt." >&2
  return
fi

# define pathmunge, and use that for $PATH manipulation.
# pathmunge is normally provided in RHEL environments,
# and this is copied almost wholesale from their implementation.
pathmunge(){
  if grep -v -E -q "(^|:)${1}(\$|:)" <<< "${PATH}"; then
    [[ -d ${1} ]] || return
    if [[ ${2} = "after" ]] ; then
      PATH="${PATH}:${1}"
    else
      PATH="${1}:${PATH}"
    fi
  fi
}

# Source system-wide bash completion if it exists
# shellcheck source=/dev/null
[[ -f /etc/bash_completion ]] && source '/etc/bash_completion'

# This is an OS Specific switchyard: figure out what
# environment this is being run in, and configure it
# accordingly. Currently supports Solaris, macOS & Linux.
case "$(uname -s)" in
  # All linux configuration goes here
  Linux*)

    ## Have we got local bin paths? Prepend them.
    pathmunge /usr/local/sbin before
    pathmunge /usr/local/bin before
  ;;

  # This is for the 3 or 4 solaris machines you might encounter
  SunOS*)
    # Seriously. I want to know.
    echo -e "\n\nWhere did you find a Solaris machine? Sun is dead"
    echo -e "and Oracle EOL'ed Solaris in August 2017. RIP Solaris.\n\n"

    # Don't even bother with whatever path we've inherited. Build a new one.
    # Make sure that pathmunge is a function, not some weird whoknowswhat
    if type pathmunge | grep -q function; then
      pathmunge /bin before
      pathmunge /usr/bin before
      pathmunge /sbin after
      pathmunge /usr/sbin after
      pathmunge /usr/xpg4/bin before
      pathmunge /usr/local/bin before
      pathmunge /usr/local/sbin before
      pathmunge /opt/SUNWspro/bin before
      pathmunge /usr/ccs/bin before
      pathmunge /hub/SunOS/5.8/sun4u/apps/openssh-3.0p1/bin before
    fi

    # If the TERM isn't something sane, lie
    [[ ${TERM} =~ xterm-color ]] && export TERM=xterm
  ;;

  # This is for macOS.
  Darwin*)

    # Here's some paths that might exist. If they do, we wants them so badly!
    pathmunge /opt/local/sbin before
    pathmunge /opt/local/bin before
    pathmunge /usr/local/sbin before
    pathmunge /usr/local/bin before
    pathmunge /Developer/Tools after
    pathmunge /usr/local/mysql/bin after

    # Gotta clear that DNS cache somehow, right?
    flushdns(){
      sudo killall -HUP mDNSResponder
      return $?
    }

    # View man pages as PDF files
    pman(){
      command man -t "${@}" | open -g -f -a /Applications/Preview.app
      return $?
    }

    # Don't bother with `locate` or any findutils nonsense. Just use Spotlight.
    alias locate='mdfind -name'
  ;;
esac

###### Aliases & Functions: make your life easier ######

# sorted list of the contents of PWD or $1
alias howbig='du -Lh --max-depth=1'

# General aliases
alias ..='cd ..'
alias mkdir='mkdir -p'
alias du='du -h'
alias df='df -Th'

# generic psgrep
alias psgrep="ps auxww | grep -i"
# generic history grep
alias hgrep="history | grep -i"
# Rehash the path using the principle of least surprise
alias rehash="hash -r"

# Load everything in ~/.profile.d if it exists
__counter=0
__profiles="${HOME}/.profile.d"
__secrets="${HOME}/.private.d"
__dim='\033[2m'
__normal='\033[22m'

if [[ -d ${__profiles} ]]; then
  shopt -s nullglob

  # Private files, which should not be tracked
  # anywhere public. Probably contains tokens,
  # API keys, etc.
  if [[ -d ${__secrets} ]]; then
    for __file in "${__secrets}"/*.sh; do
      # shellcheck source=/dev/null
      source "${__file}"
      __counter=$((__counter + 1))
    done

    # If any secrets were sourced, print the count and reset the counter
    if [[ ${__counter} -gt 0 ]]; then
      if [[ ${TERM} =~ xterm ]]; then
        printf "%b> Loaded %2s sub-profiles from %s%b\\n" "${__dim}" "${__counter}" "${__secrets}" "${__normal}"
        __counter=0
      fi
    fi
  fi

  # Pre files
  for __file in "${__profiles}"/pre_*.sh; do
    # shellcheck source=/dev/null
    source "${__file}"
    __counter=$((__counter + 1))
  done

  # Anything not tagged pre or post
  for __file in "${__profiles}"/*.sh; do
    [[ ${__file##*/} =~ ^pre_|post_ ]] && continue
    # shellcheck source=/dev/null
    source "${__file}"
    __counter=$((__counter + 1))
  done

  # Post files
  for __file in "${__profiles}"/post_*.sh; do
    # shellcheck source=/dev/null
    source "${__file}"
    __counter=$((__counter + 1))
  done
  shopt -u nullglob
fi

# Wrap up counting the seconds since this started
__end="$(date +"%s")"

# Dump to screen and let me get on with my life!
if [[ ${TERM} =~ xterm ]]; then
  printf "%b> Loaded %02d sub-profiles from %s%b\\n" "${__dim}" "${__counter}" "${__profiles}" "${__normal}"
  printf "%b> Profile loaded in %s seconds%b\\n" "${__dim}" "$((__end-__begin))" "${__normal}"
fi
unset __counter __profiles
