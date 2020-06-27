#!/bin/sh

# delets all helm chart generated alert rules 
kubectl get prometheusrules.monitoring.coreos.com --namespace=default | grep -v example | awk '{if(NR>1)print " delete prometheusrules.monitoring.coreos.com --namespace=default "$1;}' | xargs kubectl

