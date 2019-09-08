#!/bin/bash
NODES=$(echo node{1..3})
for NODE in ${NODES}; do
# multipass exec ${NODE} -- bash -c 'echo `ip -4 addr show enp0s2 | grep -oP "(?<=inet ).*(?=/)"` `echo $(hostname)` | sudo tee -a /etc/hosts'
multipass exec ${NODE} -- bash -c 'echo `ip -4 addr show enp0s2 | grep -oP "(?<=inet ).*(?=/)"` `echo $(hostname)`'
done
