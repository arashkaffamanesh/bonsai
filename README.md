# Rancher k3s and Rancher Server on Multipass VMs on your local machine

## Who should use this?

Those who'd love to have a light weight k3s implementation on multipass VMs on their local machine. For a full-fledged RKE installation on multipass VMs, please refer to:

https://github.com/arashkaffamanesh/multipass-rke-rancher

## Prerequisites

You need Multipass running on your local machine, to learn more about Multipass, please visit:

https://github.com/CanonicalLtd/multipass

https://multipass.run/

This setup was tested on MacOS, but should work on Linux or Windows too.

You need to have about 4GB free RAM and 16GB free storage on your local machine, but it should work with less resources.

## Installation

### Install multipass (on MacOS or Linux)

```bash
brew cask install multipass
sudo snap install multipass --beta --classic
```

Clone this repo and run the scripts as follow:

```bash
git clone https://github.com/arashkaffamanesh/multipass-k3s-rancher.git
cd multipass-k3s-rancher
./1-deploy-multipass-vms.sh
./2-deploy-k3s.sh
./3-deploy-rancher-on-k3s.sh
```

## What you get

You should get a running k3s cluster on 4 Multipass VMs with Rancher Server on top in about 15 minutes. Node1 is the master, all other 3 nodes are the workers.

## Access the Rancher Server on k3s

You should use kubectl port-forward to access the Rancher Server, e.g.:

```bash
kkubectl port-forward rancher-797f8646f6-pxht7 -n cattle-system 8443:443
```

## Clean Up

```bash
multipass stop node1 node2 node3 node4
multipass delete node1 node2 node3 node4
multipass purge
```

## Blog post

Blog post will be published on medium:

https://blog.kubernauts.io/


