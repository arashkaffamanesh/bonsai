#!/bin/sh
kubectl delete secret promo-grafana --namespace=monitoring

sleep 5

kubectl apply -f ./grafana/grafana-config.yaml
