#!/bin/bash
export KUBECONFIG=k3s.yaml
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
curl -LO https://git.io/get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
helm init --service-account tiller
kubectl rollout status deployment tiller-deploy -n kube-system
# sleep 60
#helm install stable/cert-manager --name cert-manager --namespace kube-system --version v0.5.2
#sleep 60
#kubectl -n kube-system rollout status deploy/cert-manager
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm install --name rancher rancher-latest/rancher --namespace cattle-system --set hostname=node2 --set tls=external
echo "############################################################################"
echo "This should take about 5 minutes, please wait ... "
echo "in the meanwhile open a new shell, change to the install dir and run:"
echo "kubectl get all -A"
echo "to see the status of the deployment"
echo "Your browser should open in about 5 minutes and point to:"
echo "https://node2"
echo "############################################################################"
# sleep 300
kubectl -n cattle-system rollout status deploy/rancher
sleep 5
echo ""
# rancher=`./kubectl get pods -n cattle-system | grep rancher |awk 'NR==1{print $1}'`
# open https:/127.0.0.1:4443
echo "############################################################################"
echo "Hope you have fun with k3s on multipass"
echo "If you have any questions and would like to join us on Slack, here you go:"
echo "https://kubernauts-slack-join.herokuapp.com/"
# kubectl port-forward -n cattle-system $rancher 4443:443
open https://node2
# traefik dashboard
# open https://node3
