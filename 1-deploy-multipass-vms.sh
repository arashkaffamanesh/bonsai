#!/bin/bash
MASTER=$(echo "k3s-master ") && WORKER=$(echo k3s-worker{1..3})
NODES+=$MASTER
NODES+=$WORKER

# Create containers
for NODE in ${NODES}; do multipass launch --name ${NODE} --cpus 2 --mem 4G --disk 10G; done

# Wait a few seconds for nodes to be up
sleep 5

# Create the hosts file
./create-hosts.sh > hosts

echo "############################################################################"
echo "Writing multipass host entries to /etc/hosts on the VMs:"
cat hosts
echo "Now deploying k3s on multipass VMs"
echo "############################################################################"

for NODE in ${NODES}; do
multipass transfer hosts ${NODE}:
multipass transfer ~/.ssh/id_rsa.pub ${NODE}:
multipass exec ${NODE} -- sudo iptables -P FORWARD ACCEPT
multipass exec ${NODE} -- bash -c 'sudo cat /home/ubuntu/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys'
multipass exec ${NODE} -- bash -c 'sudo chown ubuntu:ubuntu /etc/hosts'
multipass exec ${NODE} -- bash -c 'sudo cat /home/ubuntu/hosts >> /etc/hosts'
done

echo "We need to write the host entries on your local machine to /etc/hosts"
echo "Please provide your sudo password:"
cp /etc/hosts etchosts
cat hosts | sudo tee -a etchosts
# workaround to get rid of characters appear as ^M in the hosts file (OSX Catalina)
tr '\r' '\n' < etchosts > etchosts.unix
cp etchosts.unix /etc/hosts

