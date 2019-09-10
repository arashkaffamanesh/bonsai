#!/bin/bash
# deploy traefik with dashboard
./kubectl delete deployment -n kube-system traefik
./kubectl delete daemonset -n kube-system svclb-traefik
./kubectl delete service -n kube-system traefik
./kubectl delete job -n kube-system helm-install-traefik
./kubectl create ns traefik
./kubectl apply -f ./traefik/ -n traefik
sleep 60
open https://node3
# username / password : admin / admin