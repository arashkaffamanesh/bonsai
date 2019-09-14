# Rancher k3s, Rancher Server and RKE cluster on Multipass VMs on your local machine

This repo provides a lightweight multi-node k3s implementation on multipass VMs on your local machine in step 1 and the deplyoment of a full-fledged RKE cluster through Rancher Server running on k3s in step 2.

For a full-fledged RKE installation with rke tool on multipass VMs, please refer to:

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

## k3s Deployment (step 1)

Clone this repo and deploy with a single command:

```bash
git clone https://github.com/arashkaffamanesh/multipass-k3s-rancher.git
cd multipass-k3s-rancher
./deploy.sh
```

## What you get in step 1

You should get a running k3s cluster on 4 Multipass VMs with Rancher Server on top in about 10 minutes. Node1 is the master, all other 3 nodes are the workers.

## Accessing the Rancher Server on k3s

A tab in your browser should open after the deployment and point to:

https://node2

Yo need to accept the self signed certificate, set the admin password and set the server url in Rancher GUI.

Note: we are using a self signed CA for node2 to be able to deploy a new RKE cluster from Rancher Server GUI running on k3s in the next step.

## Re-Deploy traefik with dashboard (optional)

If you'd like to redeploy traefik on k3s from scratch, you may want to run:

```bash
./4-deploy-traefik-dashboard.sh
```

## RKE Deployment (step 2)

Now you can launch additional multipass rke VMs (rke1..3) and install docker on them with:

```bash
./5-deploy-3-multipass-rkes.sh
```

After the install is complete, add a new cluster via Rancher GUI, use flannel as networking, copy the provided command, shell into the 3 rke nodes and fire the command on all nodes. Your new RKE cluster should show up in Rancher GUI after few minutes in running state.

## Clean Up

```bash
./cleanup.sh
./cleanup-rkes.sh
```

## Gotchas

Running `./cleanup-rkes.sh` throws an error like:

```bash
Stopping requested instances -[2019-09-14T14:49:51.096] [error] [rke1] process error occurred Crashed
```

which can be ignored.

## Credits

Thanks to the awesome folks at Rancher Labs for making k3s the first choice for a lightweight Kubernetes solution.

And thanks to Mattia Peri for his [great post](https://medium.com/@mattiaperi/kubernetes-cluster-with-k3s-and-multipass-7532361affa3) on medium, which encouraged me to automate everything with this small implementation for k3s on multipass.

## Blog post

Blog post will be published on medium:

https://blog.kubernauts.io/


