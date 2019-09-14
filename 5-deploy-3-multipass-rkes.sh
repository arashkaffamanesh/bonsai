#!/bin/bash
# multipass delete $(echo node{1..4})
NODES=$(echo rke{1..3})

# Create containers
for NODE in ${NODES}; do multipass launch --name ${NODE} --cpus 2 --mem 2G --disk 8G; done

# Wait a few seconds for nodes to be up
sleep 5

echo "############################################################################"
echo "multipass containers installed:"
multipass ls
echo "############################################################################"

# Install Docker
for NODE in ${NODES}; do
    multipass exec ${NODE} -- bash -c 'curl https://releases.rancher.com/install-docker/18.09.sh | sh'
	# multipass exec ${NODE} -- bash -c 'curl https://releases.rancher.com/install-docker/19.03.sh | sh'
	multipass exec ${NODE} -- sudo usermod -aG docker multipass
	multipass exec ${NODE} -- sudo docker --version
done

# Create the hosts file
./create-rke-hosts.sh > rke-hosts

echo "############################################################################"
echo "Writing multipass host entries to /etc/hosts on the VMs:"
cat rke-hosts
echo "############################################################################"

for NODE in ${NODES}; do
multipass transfer hosts ${NODE}:/home/multipass/hosts
multipass transfer rke-hosts ${NODE}:/home/multipass/rke-hosts
multipass transfer ~/.ssh/id_rsa.pub ${NODE}:/home/multipass/
multipass transfer extended-cleanup-rancher2.sh ${NODE}:/home/multipass/
multipass exec ${NODE} -- sudo iptables -P FORWARD ACCEPT
multipass exec ${NODE} -- bash -c 'sudo cat /home/multipass/id_rsa.pub >> /home/multipass/.ssh/authorized_keys'
multipass exec ${NODE} -- bash -c 'sudo chown multipass:multipass /etc/hosts'
multipass exec ${NODE} -- bash -c 'sudo cat /home/multipass/rke-hosts >> /etc/hosts'
multipass exec ${NODE} -- bash -c 'sudo cat /home/multipass/hosts >> /etc/hosts'
done

echo "We need to write the rke-host entries on your local machine to /etc/hosts"
echo "Please provide your sudo password:"
cat rke-hosts | sudo tee -a /etc/hosts

