#!/bin/bash
multipass stop rke1 rke2 rke3
multipass delete rke1 rke2 rke3
multipass purge
rm rke-hosts
echo "Please cleanup the host entries in your /etc/hosts manually"