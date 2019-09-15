#!/bin/bash
export KUBECONFIG=rke.yaml
kubectl -n kube-system create serviceaccount tiller
kubectl create clusterrolebinding tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
curl -LO https://git.io/get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh
helm init --service-account tiller
kubectl rollout status deployment tiller-deploy -n kube-system
export HELM_HOST=":44134"
tiller -listen ${HELM_HOST} -alsologtostderr >/dev/null 2>&1 &
helm install --name=maesh --namespace=maesh maesh/maesh