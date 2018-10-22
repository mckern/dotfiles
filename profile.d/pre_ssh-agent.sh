#!/usr/bin/env bash

test_socket() {
  if [[ ${SSH_AUTH_SOCK+_} && -S ${SSH_AUTH_SOCK} ]]; then
    : "Socket found"
    return 0
  fi
  : "No socket found"
  return 1
}

initialize_socket() {
  local ssh_conf_dir="${SSH_CONF_DIR:-${HOME}/.ssh}"
  local ssh_agent_conf="${SSH_AGENT_CONF:-${ssh_conf_dir}/agent}"
  local ssh_agent="${SSH_AGENT:-$(command -v ssh-agent 2>/dev/null)}"

  # Ensure that an SSH agent command exists
  if [[ -z ${ssh_agent} ]]; then
    : "No SSH agent found"
    return 1
  fi

  # Ensure that the ssh config directory exists
  if [[ ! -d ${ssh_conf_dir} ]]; then
    : "No SSH configuration directory (${ssh_conf_dir}) exists"
    return 1
  fi

  # Initialize the socket since nothing has been found
  if "${ssh_agent}" -s | head -n2 > "${ssh_agent_conf}"; then
    # shellcheck source=/dev/null
    source "${ssh_agent_conf}"
    return 0
  fi
  return 1
}

# See if there's a socket, and initialize a socket if there's not
test_socket || initialize_socket
unset initialize_socket
unset test_socket
