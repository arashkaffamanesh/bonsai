#!/bin/bash
export KUBECONFIG=rke.yaml
NODES=$(echo rke{1..3})

for NODE in ${NODES}; do
multipass exec ${NODE} -- bash -c 'sudo systemctl enable iscsid && sudo systemctl start iscsid'
done

kubectl apply -f https://openebs.github.io/charts/openebs-operator-1.2.0.yaml