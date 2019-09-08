#!/bin/bash
# multipass delete $(echo node{1..4})
NODES=$(echo node{1..4})

# Create containers
for NODE in ${NODES}; do multipass launch --name ${NODE} --cpus 1 --mem 1G --disk 4G; done

# Wait a few seconds for nodes to be up
sleep 20

echo "############################################################################"
echo "multipass containers installed:"
multipass ls
echo "############################################################################"

# Print nodes ip addresses
for NODE in ${NODES}; do
	multipass exec ${NODE} -- bash -c 'echo -n "$(hostname) " ; ip -4 addr show enp0s2 | grep -oP "(?<=inet ).*(?=/)"'
	# multipass exec ${NODE} -- bash -c 'ip -4 addr show enp0s2 | grep -oP "(?<=inet ).*(?=/)";echo -n "$(hostname) "'
done

# Create the hosts file
./create-hosts.sh > hosts

for NODE in ${NODES}; do
multipass transfer hosts ${NODE}:/home/multipass/
multipass exec ${NODE} -- bash -c 'sudo chown multipass:multipass /etc/hosts'
multipass exec ${NODE} -- bash -c 'sudo cat /home/multipass/hosts >> /etc/hosts'
done

echo "############################################################################"
echo "Make sure your /etc/hosts file on your localhost and the multipass hosts"
echo "have these host entries like:"
cat hosts
echo ""
echo "You have to set the host entries on your localhost manually"
echo "and run ./2-deploy-k3s.sh"
echo "############################################################################"