#!/bin/bash
export KUBECONFIG=`pwd`/k3s.yaml && echo '[Info] setting KUBECONFIG='$KUBECONFIG

WORKERS=$(echo multipass list | grep worker | awk '{print $1}')

for NODE in ${WORKERS}; do
multipass exec ${NODE} -- bash -c 'sudo systemctl enable iscsid && sudo systemctl start iscsid'
done

kubectl apply -f https://openebs.github.io/charts/openebs-operator-1.10.0.yaml
kubectl rollout status deployment -n openebs maya-apiserver
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"false"}}}'
kubectl patch storageclass openebs-hostpath -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

# deploy postgres for test

# helm install --name postgres --set persistence.storageClass=openebs-hostpath stable/postgresql
