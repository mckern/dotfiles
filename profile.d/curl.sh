#!/usr/bin/env bash

function urldecode() {
  local url="${1}"
  python -c "import sys, urllib; print urllib.unquote_plus('${url}')"
  return $?
}

function urlencode() {
  local url="${1}"
  python -c "import sys, urllib; print urllib.quote_plus('${url}')"
  return $?
}

if type -P curl &>/dev/null; then
  # Return the status code and effective, post-redirected state of a URL
  statuscode() {
    [[ ${1:-UNSET} == "UNSET" ]] && return 1
    local action="${2:-GET}"

    curl \
      --request "${action}" \
      --silent \
      --include \
      --write-out "%{url_effective} %{http_code}\\n" \
      --output /dev/null \
      "${1}"
    return $?
  }

  contenttype() {
    [[ ${1:-UNSET} == "UNSET" ]] && return 1
    local action="${2:-GET}"

    curl \
      --request "${action}" \
      --silent \
      --include \
      --location \
      --write-out "%{url_effective} %{content_type}\\n" \
      --output /dev/null \
      "${1}"
    return $?
  }

  headers() {
    [[ ${1:-UNSET} == "UNSET" ]] && return 1

    curl \
      --request GET \
      --silent \
      --include \
      --location \
      --head \
      "${1}"
    return $?
  }

  curl-sha256() {
    [[ ${1:-UNSET} == "UNSET" ]] && return 1

    curl \
      --progress-bar \
      --location \
      "${1}" |
      sha256sum |
      awk '{print $1}'
    return $?
  }

  curl-md5sum() {
    [[ ${1:-UNSET} == "UNSET" ]] && return 1

    curl \
      --progress-bar \
      --location \
      "${1}" |
      md5sum |
      awk '{print $1}'
    return $?
  }

  brute-curl() {
    [[ ${1:-UNSET} == "UNSET" ]] && return 1

    local no_params="${1%%\?*}"
    local output_file="${no_params##*/}"
    : "${output_file:="${2}"}"
    local user_agent="Mozilla/5.0 AppleWebKit/537.36 (KHTML, like Gecko; compatible; Googlebot/2.1; +http://www.google.com/bot.html) Safari/537.36"

    while true; do
      curl \
        --user-agent "${user_agent}" \
        --progress-bar \
        --continue-at - \
        --output "${output_file}" \
        --location \
        "${1}" && break
    done
    return $?
  }
fi
