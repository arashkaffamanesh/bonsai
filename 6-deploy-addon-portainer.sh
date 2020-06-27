#!/bin/bash
GREEN='\033[0;32m'
LB='\033[1;34m' # light blue
NC='\033[0m' # No Color

./2-deploy-k3s.sh

export KUBECONFIG=`pwd`/k3s.yaml && echo -e "[${LB}Info${NC}] setting KUBECONFIG=${KUBECONFIG}"

echo -e "[${LB}Info${NC}] deploy metallb loadbalancer"
kubectl create -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml >/dev/null
kubectl create -f metal-lb-layer2-config.yaml >/dev/null
kubectl rollout status -n metallb-system daemonset speaker >/dev/null
kubectl get nodes

echo "are the nodes ready?"
echo "if you face problems, please open an issue on github"
echo -e "[${LB}Info${NC}] deploy portainer"
kubectl create -f addons/portainer/portainer.yaml  >/dev/null
kubectl rollout status -n portainer deployment portainer  >/dev/null
portainer_ip=`kubectl get svc -n portainer | grep portainer | awk 'NR==1{print $4}'`

sleep 5

open http://$portainer_ip:9000

echo -e "[${GREEN}FINISHED${NC}]"
echo "############################################################################"
