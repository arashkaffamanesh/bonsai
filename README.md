# Rancher k3s and Rancher Server on Multipass VMs on your local machine

## Who should use this?

Those who'd love to have a lightweight real multi-node k3s implementation on multipass VMs on their local machine. For a full-fledged RKE installation on multipass VMs, please refer to:

https://github.com/arashkaffamanesh/multipass-rke-rancher

## Prerequisites

You need Multipass running on your local machine, to learn more about Multipass, please visit:

https://github.com/CanonicalLtd/multipass

https://multipass.run/

This setup was tested on MacOS, but should work on Linux or Windows too.

You need to have about 4GB free RAM and 16GB free storage on your local machine, but it should work with less resources.

You need sudo rights on your machine.

## Installation

### Install multipass (on MacOS or Linux)

```bash
brew cask install multipass (on MacOS)
sudo snap install multipass --beta --classic (on linux)
```

Clone this repo and deploy with a single command:

```bash
git clone https://github.com/arashkaffamanesh/multipass-k3s-rancher.git
cd multipass-k3s-rancher
./deploy.sh
```

## What you get

You should get a running k3s cluster on 4 Multipass VMs with Rancher Server on top in about 10 minutes. Node1 is the master, all other 3 nodes are the workers.

## Accessing the Rancher Server on k3s

A tab in your browser should open after the deployment and point to:

https://node2

Yo need to accept the self signed certificate, set the admin password and set the server url.

If something goes wrong, please use kubectl port-forward to access the Rancher Server, e.g.:

## Re-Deploy traefik with dashboard

If you'd like to redeploy traefik from scratch, you may want to run:

```bash
./4-deploy-traefik-dashboard.sh
```

## Clean Up

```bash
./cleanup.sh
```

## Credits

Thanks to the awesome folks at Rancher Labs for making k3s the first choice for a lightweight Kubernetes solution.

And thanks to Mattia Peri for his [great post](https://medium.com/@mattiaperi/kubernetes-cluster-with-k3s-and-multipass-7532361affa3) on medium, which encouraged me to automate everything with this small implementation for k3s on multipass.

## Blog post

Blog post will be published on medium:

https://blog.kubernauts.io/


