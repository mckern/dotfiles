#!/usr/bin/env bash

complete -C aws_completer aws

if [[ -f ~/.aws/aws_credential_file ]]; then
  export AWS_CREDENTIAL_FILE=~/.aws/aws_credential_file
fi
