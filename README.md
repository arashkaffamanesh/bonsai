# Rancher k3s and Rancher Server on Multipass VMs on your local machine

## Who should use this?

Those who'd love to have a lightweight real multi-node k3s implementation on multipass VMs on their local machine. For a full-fledged RKE installation on multipass VMs, please refer to:

https://github.com/arashkaffamanesh/multipass-rke-rancher

## Prerequisites

### Install multipass (on MacOS or Linux)

You need Multipass running on your local machine, to learn more about Multipass, please visit:

https://github.com/CanonicalLtd/multipass

https://multipass.run/

```bash
brew cask install multipass (on MacOS)
sudo snap install multipass --beta --classic (on linux)
```

This setup was tested on MacOS, but should work on Linux or Windows too.

You need to have about 4GB free RAM and 16GB free storage on your local machine, but it should work with less resources.

You need sudo rights on your machine.

You need kubectl in your path, if not, you can download the v1.15.0 version and put it in your path:

MacOS users:

```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/darwin/amd64/kubectl
```

Linux users:

```bash
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.15.0/bin/linux/amd64/kubectl
```

```bash
chmod +x ./kubectl
mv kubectl /usr/local/bin/
```

### Important hint for linux users

Linux users should adapt the `create-hosts.sh` and adapt the network interface name. You can find the nic name with:

```bash
multipass launch --name test
multipass exec test -- bash -c 'echo `ls /sys/class/net | grep en`'
```

Delete and purge the test VM:

```bash
multipass delete test
multipass purge
```

If the above doesn't work somehow, shell into the node and get the nic name:

```bash
multipass shell test
ifconfig
```

## Installation

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


