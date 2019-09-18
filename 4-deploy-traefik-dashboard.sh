#!/bin/bash
# deploy traefik with dashboard
export KUBECONFIG=k3s.yaml
kubectl delete deployment -n kube-system traefik
kubectl delete daemonset -n kube-system svclb-traefik
kubectl delete service -n kube-system traefik
kubectl delete job -n kube-system helm-install-traefik
kubectl create ns traefik
kubectl apply -f ./traefik/ -n traefik
kubectl -n traefik rollout status deployment traefik-ingress-controller
#sleep 90
open https://node3
# username / password : admin / admin