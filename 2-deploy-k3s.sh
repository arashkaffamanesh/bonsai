#!/bin/bash

# Deploy k3s master on node1
multipass exec node1 -- /bin/bash -c "curl -sfL https://get.k3s.io | sh -"
# Get the IP of the master node
K3S_NODEIP_MASTER="https://$(multipass info node1 | grep "IPv4" | awk -F' ' '{print $2}'):6443"
# Get the TOKEN from the master node
K3S_TOKEN="$(multipass exec node1 -- /bin/bash -c "sudo cat /var/lib/rancher/k3s/server/node-token")"
# Deploy k3s on the worker nodes node2,node3,node4
multipass exec node2 -- /bin/bash -c "curl -sfL https://get.k3s.io | K3S_TOKEN=${K3S_TOKEN} K3S_URL=${K3S_NODEIP_MASTER} sh -"
multipass exec node3 -- /bin/bash -c "curl -sfL https://get.k3s.io | K3S_TOKEN=${K3S_TOKEN} K3S_URL=${K3S_NODEIP_MASTER} sh -"
multipass exec node4 -- /bin/bash -c "curl -sfL https://get.k3s.io | K3S_TOKEN=${K3S_TOKEN} K3S_URL=${K3S_NODEIP_MASTER} sh -"
sleep 10

echo "############################################################################"
# multipass exec node1 -- bash -c "sudo kubectl get nodes"
multipass exec node1 -- bash -c 'sudo cat /etc/rancher/k3s/k3s.yaml' > k3s.yaml
sed -i'.back' -e 's/127.0.0.1/node1/g' k3s.yaml
# export KUBECONFIG=k3s.yaml
KUBECONFIG=k3s.yaml kubectl taint node node1 node-role.kubernetes.io/master=effect:NoSchedule
KUBECONFIG=k3s.yaml kubectl label node node2 node-role.kubernetes.io/node=
KUBECONFIG=k3s.yaml kubectl label node node3 node-role.kubernetes.io/node=
KUBECONFIG=k3s.yaml kubectl label node node4 node-role.kubernetes.io/node=
KUBECONFIG=k3s.yaml kubectl get nodes
echo "are the nodes ready?"
echo "if you face problems, please open an issue on github"
echo ""
echo "############################################################################"
