#!/bin/bash
# multipass exec node1 -- bash -c 'echo `ls /sys/class/net | grep en`' > nic_name
# nic_name=`cat nic_name`
NODES=$(echo rke{1..3})
for NODE in ${NODES}; do
# multipass exec ${NODE} -- bash -c 'echo `ip -4 addr show enp0s2 | grep -oP "(?<=inet ).*(?=/)"` `echo $(hostname)` | sudo tee -a /etc/hosts'
multipass exec ${NODE} -- bash -c 'echo `ip -4 addr show enp0s2 | grep -oP "(?<=inet ).*(?=/)"` `echo $(hostname)`'
# multipass exec ${NODE} -- bash -c 'echo `ip -4 addr show $nic_name | grep -oP "(?<=inet ).*(?=/)"` `echo $(hostname)`'
# on CentOS linux on some machines the nic is named ens3
# multipass exec ${NODE} -- bash -c 'echo `ip -4 addr show ens3 | grep -oP "(?<=inet ).*(?=/)"` `echo $(hostname)`'
done
