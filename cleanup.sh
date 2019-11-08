#!/bin/bash
multipass stop node1 node2 node3 node4
multipass delete node1 node2 node3 node4
multipass purge
rm hosts k3s.yaml.back k3s.yaml get_helm.sh etchosts etchosts.unix
echo "Please cleanup the host entries in your /etc/hosts manually"