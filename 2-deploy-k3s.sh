#!/bin/bash
GREEN='\033[0;32m'
LB='\033[1;34m' # light blue
NC='\033[0m' # No Color

echo "############################################################################"
echo "Now deploying k3s on multipass VMs"

echo -e "[${LB}Info${NC}] deploy k3s on k3s-master"
multipass exec k3s-master -- /bin/bash -c "curl -sfL https://get.k3s.io | sh -" | grep Using
# Get the IP of the master node
K3S_NODEIP_MASTER="https://$(multipass info k3s-master | grep "IPv4" | awk -F' ' '{print $2}'):6443"
# Get the TOKEN from the master node
K3S_TOKEN="$(multipass exec k3s-master -- /bin/bash -c "sudo cat /var/lib/rancher/k3s/server/node-token")"
# Deploy k3s on the worker nodes node2,node3,node4

WORKERS=$(echo $(multipass list | grep worker | awk '{print $1}'))
for WORKER in ${WORKERS}; 
do echo -e "[${LB}Info${NC}] deploy k3s on ${WORKER}" && multipass exec ${WORKER} -- /bin/bash -c "curl -sfL https://get.k3s.io | K3S_TOKEN=${K3S_TOKEN} K3S_URL=${K3S_NODEIP_MASTER} sh -" | grep -w "Using"; 
done
sleep 10

echo "############################################################################"
echo exporting KUBECONFIG file from master node
multipass exec k3s-master -- bash -c 'sudo cat /etc/rancher/k3s/k3s.yaml' > k3s.yaml
sed -i'.back' -e 's/127.0.0.1/k3s-master/g' k3s.yaml
export KUBECONFIG=`pwd`/k3s.yaml && echo -e "[${LB}Info${NC}] setting KUBECONFIG=${KUBECONFIG}"

echo -e "[${LB}Info${NC}] tainting master node: k3s-master"
kubectl taint node k3s-master node-role.kubernetes.io/master=effect:NoSchedule

for WORKER in ${WORKERS}; do kubectl label node ${WORKER} node-role.kubernetes.io/node=  > /dev/null && echo -e "[${LB}Info${NC}] label ${WORKER} with node"; done

kubectl get nodes

echo "are the nodes ready?"
echo "if you face problems, please open an issue on github"
echo -e "[${GREEN}FINISHED${NC}]"
echo "############################################################################"
