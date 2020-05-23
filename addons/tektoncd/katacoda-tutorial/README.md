# From Katacoda Tutorial

https://katacoda.com/popcor255/scenarios/getting-started-tekton-pipelines

```bash
kubectl apply -f echo-hello-world-task.yaml

kubectl apply -f echo-hello-world-task-run.yaml

tkn taskrun describe echo-hello-world-task-run

kubectl apply -f hello-world-git.yaml

kubectl apply -f hello-world-image.yaml

kubectl apply -f build-and-push-docker-image-from-git-task.yaml

# Note: You need to get your Docker access token at https://hub.docker.com/settings/security.

# Adapt the creds below (use the token!):

kubectl create secret docker-registry regcred --docker-server=docker.io --docker-username=<username> --docker-password=<token> --docker-email=<email>

kubectl apply -f tutorial-service-account.yaml

kubectl apply -f build-and-push-docker-image-from-git-task-run.yaml

kubectl get tekton-pipelines

tkn taskrun logs build-and-push-docker-image-from-git-task-run

kubectl apply -f tutorial-pipeline.yaml

kubectl apply -f deploy-using-kubectl-task.yaml

kubectl create clusterrole tutorial-role --verb=create,list,get,watch --resource=pods,deployments,deployments.apps

# Namespace adapted from default to tekton-pipelines

kubectl create clusterrolebinding tutorial-binding --clusterrole=tutorial-role --serviceaccount=tekton-pipelines:tutorial-service

kubectl apply -f  tutorial-pipeline-run-1.yaml

tkn pipelinerun describe tutorial-pipeline-run-1
```


