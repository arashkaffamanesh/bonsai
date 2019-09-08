#!/bin/bash
export KUBECONFIG=k3s.yaml
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
curl -LO https://git.io/get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
helm init --service-account tiller
sleep 60
helm install stable/cert-manager --name cert-manager --namespace kube-system --version v0.5.2
sleep 60
kubectl -n kube-system rollout status deploy/cert-manager
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm install --name rancher rancher-latest/rancher --namespace cattle-system --set hostname=node2 --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=devops@kubernauts.de
echo "############################################################################"
echo "This should take about 4 minutes, wait ... "
echo "open a new shell and run:"
echo "kubectl get all -A to see the status of the deployment"
echo "and run something like:"
echo "kubectl port-forward -n cattle-system rancher-5d57b47d5f-9ck7f 8443:443"
echo "and access the Rancher Server by calling:"
echo "https://localhost:8443"
echo "############################################################################"
sleep 240
# open https:/node2 # needs more work