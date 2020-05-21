# Tekton Pipelines on Bonsai

kubectl apply -f tekton-plus-dashboard-lb-service.yaml

dashboard_ip=`kubectl get svc -n tekton-pipelines | grep tekton-dashboard | awk 'NR==1{print $4}'`

open http://$dashboard_ip:9097

## Tekton Pipelines on Github

https://github.com/tektoncd/pipeline

https://github.com/tektoncd/pipeline/blob/master/docs/tutorial.md

## Open-Toolchain Tekton Catalog

https://github.com/open-toolchain/tekton-catalog
