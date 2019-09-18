#!/bin/bash

kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.7.3/manifests/metallb.yaml

cat <<'_EOF_'> bgp.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    peers:
    - my-asn: 64522
      peer-asn: 64512
      peer-address: 192.168.178.1
      peer-port: 179
      router-id: 192.168.178.1
    address-pools:
    - name: my-ip-space
      protocol: bgp
      avoid-buggy-ips: true
      addresses:
      - 192.168.178.192/26
_EOF_

kubectl apply -f bgp.yaml
kubectl apply -f ghost-deployment.yaml
kubectl expose deployments ghost --port=2368 --type=LoadBalancer
kubectl apply -f ghost-ingress.yaml
# multipass exec node2 -- bash -c "curl 192.168.178.193:2368"

