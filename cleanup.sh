#!/bin/bash
GREEN='\033[0;32m'
LB='\033[1;34m' # light blue
NC='\033[0m' # No Color

MASTER=$(echo $(multipass list | grep master | awk '{print $1}'))
WORKERS=$(echo $(multipass list | grep worker | awk '{print $1}'))
NODES+=$MASTER
NODES+=" "
NODES+=$WORKERS

# Stop then delete nodes
for NODE in ${NODES}; do multipass stop ${NODE} && multipass delete ${NODE}; done
# Free discspace
multipass purge

rm hosts k3s.yaml.back k3s.yaml get_helm.sh etchosts etchosts.unix 2> /dev/null
echo -e "[${GREEN}FINISHED${NC}]"
echo "############################################################################"
echo -e "[${LB}Info${NC}] Please cleanup the host entries in your /etc/hosts manually"
