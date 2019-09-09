#!/bin/bash
multipass stop node1 node2 node3 node4
multipass delete node1 node2 node3 node4
multipass purge
rm hosts kubectl k3s.yaml.back k3s.yaml get_helm.sh