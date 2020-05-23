#!/bin/bash
NODES=$(echo node{1..4})

# Stop then delete nodes
for NODE in ${NODES}; do multipass stop ${NODE} && multipass delete ${NODE}; done
# Free discspace
multipass purge

rm hosts k3s.yaml.back k3s.yaml get_helm.sh etchosts etchosts.unix
echo "Please cleanup the host entries in your /etc/hosts manually"
