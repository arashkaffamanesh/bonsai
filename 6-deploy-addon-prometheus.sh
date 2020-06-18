#!/bin/bash
GREEN='\033[0;32m'
LB='\033[1;34m' # light blue
NC='\033[0m' # No Color

export KUBECONFIG=`pwd`/k3s.yaml && echo -e '[${LB}Info${NC}] setting KUBECONFIG='$KUBECONFIG

read -p  "Do you want to deploy Metallb as Loadbalancer? type "y/n" promt with [ENTER]:" ans

answer=$(echo "$ans" | awk '{print tolower($0)}')


echo -e "[${LB}Info${NC}] ...installing tiller"
kubectl -n kube-system create serviceaccount tiller >/dev/null
kubectl create clusterrolebinding tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller >/dev/null
curl -LO https://git.io/get_helm.sh >/dev/null
chmod 700 get_helm.sh >/dev/null
./get_helm.sh >/dev/null
helm init --service-account tiller >/dev/null
kubectl rollout status deployment tiller-deploy -n kube-system

sleep 5

echo -e "[${LB}Info${NC}] ...deploying promehteus 8.13.0 via helm v2 in namespace=monitoring"
helm install stable/prometheus-operator --name promo --version=8.13.0 --namespace monitoring

echo -e "[${LB}Info${NC}] deploy alertmessages to the alertmanager"
./addons/blackbox-exporter/alertmanager-config.sh

echo -e "[${LB}Info${NC}] setup a namespace for separation"
kubectl apply -f addons/example/1-application-ns.yml

echo -e "[${LB}Info${NC}] deploy the scrap configuration"
kubectl apply -f addons/example/2-application-deployment-configmap.yml

echo -e "[${LB}Info${NC}] deploy the application"
kubectl apply -f addons/example/3-application-deployment.yml

echo -e "[${LB}Info${NC}] deploy the service"
kubectl apply -f addons/example/4-application-service.yml

echo -e "[${LB}Info${NC}] deploy prometheus alertrule/s"
kubectl apply -f addons/example/5-application-alertrule.yml

echo -e "[${LB}Info${NC}] deploy ServiceMonitors to connect the service with prometheues targetservice"
kubectl apply -f addons/example/6-application-service.yml

echo -e "[${LB}Info${NC}] deploy grafana config"
kubectl apply -f addons/grafana/grafana-config.sh

# cleanup
rm get_helm.sh

if [ $answer != 'y' ];
then
  echo "Metallb will not be deployed."
else
  echo -e "[${LB}Info${NC}] deploy metallb loadbalancer v0.8.3"
  kubectl create -f https://raw.githubusercontent.com/google/metallb/v0.8.3/manifests/metallb.yaml >/dev/null
  kubectl create -f metal-lb-layer2-config.yaml >/dev/null
  kubectl rollout status -n metallb-system daemonset speaker
  
  echo -e "[${LB}Info${NC}] deploy grafana expose service"
  kubectl create -f addons/grafana/promo-grafana-expose-service.yaml
fi

echo '[Hints] operator fails, dont use - in namespace name'
echo '[Hints] alertmanager fails, remember to set a alert url'

echo -e "[${GREEN}FINISHED${NC}]"
echo "############################################################################"