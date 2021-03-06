#!/usr/bin/env bash

# Arguments: file to check, how old is too old (optional)
expired() {
  local file
  file="${1}"

  if ! [[ -f ${file} ]]; then
    echo "${file} not found" >&2
    return 0
  fi

  local timestamp
  timestamp="$(/bin/date -r "${file}" "+%s")"

  local expiry
  expiry="${2:-7200}"

  local now
  now="$(/bin/date '+%s')"
  if ! [[ ${timestamp} =~ ^-?[0-9]+$ ]]; then
    echo "${timestamp} is not an integer" >&2
    return 1
  fi

  local delta
  delta=$((now - timestamp))
  # If the timestamp is more than two hours ago, it's expired
  if [[ ${delta} -gt ${expiry} ]]; then
    return 0
  fi

  return 1
}

cache_homebrew() {
  local file
  file="${1}"

  local type
  type="${2:-formula}"

  if ! [[ -f ${file} ]]; then
    case "${type}" in
      formula)
        brew list > "${file}"
        return "${?}"
        ;;
      cask)
        brew cask list > "${file}"
        return "${?}"
        ;;
    esac
  fi
}

# If we're using homebrew to manage things, prepend the relevant bits
if ! command -v brew > /dev/null 2>&1; then
  return
fi

export \
  HOMEBREW_NO_ANALYTICS=true \
  HOMEBREW_NO_EMOJI=true \
  HOMEBREW_UPDATE_TO_TAG=true

brew_prefix="$(brew --prefix)"
cask_prefix="${brew_prefix}/Caskroom"

brew_dir="${HOME}/.homebrew.d"
[[ -d ${brew_dir} ]] || mkdir -p "${brew_dir}"

formula_cache="${brew_dir}/formula"
cask_cache="${brew_dir}/casks"

# Cache formula if the cache is stale
if expired "${formula_cache}"; then
  cache_homebrew "${formula_cache}" "formula"
fi

# Cache casks if the cache is stale
if expired "${cask_cache}"; then
  cache_homebrew "${cask_cache}" "cask"
fi

# Read the cache, and use that for all future comparisons
all_formula="$(< "${formula_cache}")"
all_casks="$(< "${cask_cache}")"

# now configure convenience paths, env. vars, etc.
# based on what formulas are installed

if grep -q -E '^go$' <<< "${all_formula}"; then
  export GOPATH="${brew_prefix}/var/go"
  export GOROOT="${brew_prefix}/opt/go/libexec"
  pathmunge "${GOPATH}/bin" before
fi

if grep -q 'gnupg' <<< "${all_formula}"; then
  GPG_TTY="$(tty)"
  export GPG_TTY
fi

if grep -q 'ruby' <<< "${all_formula}"; then
  pathmunge "${brew_prefix}/opt/ruby/bin" before
  rehash

  ruby_version="$(ruby -e 'puts RbConfig::CONFIG["ruby_version"]')"
  pathmunge "${brew_prefix}/lib/ruby/gems/${ruby_version}/bin" before
fi

# Casks
if grep -q -E '^google-cloud-sdk$' <<< "${all_casks}"; then
  # shellcheck source=/dev/null
  source "${cask_prefix}/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
  # shellcheck source=/dev/null
  source "${cask_prefix}/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"
fi

case "${BASH_VERSINFO[0]}" in
  3)
    if grep -q bash-completion <<< "${all_formula}"; then
      # shellcheck source=/dev/null
      source "${brew_prefix}/etc/bash_completion"
    fi
    ;;
  4)
    if grep -q bash-completion2 <<< "${all_formula}"; then
      # shellcheck source=/dev/null
      source "${brew_prefix}/share/bash-completion/bash_completion"
    fi
    ;;
esac

alias cask='brew cask'

unset brew_dir
unset formula_cache
unset cask_cache
unset all_formula
unset brew_prefix
unset cask_prefix
