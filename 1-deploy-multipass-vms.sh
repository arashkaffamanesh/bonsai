#!/bin/bash
# multipass delete $(echo node{1..4})
NODES=$(echo node{1..4})

# Create containers
for NODE in ${NODES}; do multipass launch --name ${NODE} --cpus 2 --mem 2G --disk 4G; done

# Wait a few seconds for nodes to be up
sleep 5

#echo "############################################################################"
#echo "multipass containers installed:"
#multipass ls
#echo "############################################################################"

# Print nodes ip addresses
#for NODE in ${NODES}; do
#	multipass exec ${NODE} -- bash -c 'echo -n "$(hostname) " ; ip -4 addr show enp0s2 | grep -oP "(?<=inet ).*(?=/)"'
	# multipass exec ${NODE} -- bash -c 'ip -4 addr show enp0s2 | grep -oP "(?<=inet ).*(?=/)";echo -n "$(hostname) "'
#done

# Create the hosts file
./create-hosts.sh > hosts

echo "############################################################################"
echo "Writing multipass host entries to /etc/hosts on the VMs:"
cat hosts
echo "Now deploying k3s on multipass VMs"
echo "############################################################################"

for NODE in ${NODES}; do
multipass transfer hosts ${NODE}:/home/multipass/
multipass transfer ~/.ssh/id_rsa.pub ${NODE}:/home/multipass/
multipass exec ${NODE} -- sudo iptables -P FORWARD ACCEPT
multipass exec ${NODE} -- bash -c 'sudo cat /home/multipass/id_rsa.pub >> /home/multipass/.ssh/authorized_keys'
multipass exec ${NODE} -- bash -c 'sudo chown multipass:multipass /etc/hosts'
multipass exec ${NODE} -- bash -c 'sudo cat /home/multipass/hosts >> /etc/hosts'
done

echo "We need to write the host entries on your local machine to /etc/hosts"
echo "Please provide your sudo password:"
cat hosts | sudo tee -a /etc/hosts

