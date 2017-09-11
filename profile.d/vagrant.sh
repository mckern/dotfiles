#!/usr/bin/env bash

# Set a default provider based on whether or not a
# VMware provider license is found
if [[ -f ~/.vagrant.d/license-vagrant-vmware-fusion.lic ]]; then
  export VAGRANT_DEFAULT_PROVIDER='vmware_fusion'
fi
