#!/bin/bash

nodeCount=2
read -p  "How many worker nodes do you want?(default:2) promt with [ENTER]:" inputNode
nodeCount="${inputNode:-$nodeCount}"
cpuCount=2
read -p  "How many cpus do you want per node?(default:2) promt with [ENTER]:" inputCpu
cpuCount="${inputCpu:-$cpuCount}"
memCount=4
read -p  "How many gigabyte memory do you want per node?(default:4) promt with [ENTER]:" inputMem
memCount="${inputMem:-$memCount}"
diskCount=10
read -p  "How many gigabyte diskspace do you want per node?(default:10) promt with [ENTER]:" inputDisk
diskCount="${inputDisk:-$diskCount}"

MASTER=$(echo "k3s-master ") && WORKER=$(eval 'echo k3s-worker{1..'"$nodeCount"'}')
NODES+=$MASTER
NODES+=$WORKER

# Create containers
for NODE in ${NODES}; do multipass launch --name ${NODE} --cpus ${cpuCount} --mem ${memCount}G --disk ${diskCount}G; done

# Wait a few seconds for nodes to be up
sleep 5

# Create the hosts file
cp /etc/hosts hosts.backup
cp /etc/hosts hosts
./create-hosts.sh

echo "We need to write the host entries on your local machine to /etc/hosts"
echo "Please provide your sudo password:"
sudo cp hosts /etc/hosts

echo "############################################################################"
echo "Writing multipass host entries to /etc/hosts on the VMs:"

for NODE in ${NODES}; do
multipass transfer hosts ${NODE}:
multipass transfer ~/.ssh/id_rsa.pub ${NODE}:
multipass exec ${NODE} -- sudo iptables -P FORWARD ACCEPT
multipass exec ${NODE} -- bash -c 'sudo cat /home/ubuntu/id_rsa.pub >> /home/ubuntu/.ssh/authorized_keys'
multipass exec ${NODE} -- bash -c 'sudo chown ubuntu:ubuntu /etc/hosts'
multipass exec ${NODE} -- bash -c 'sudo cat /home/ubuntu/hosts >> /etc/hosts'
done
