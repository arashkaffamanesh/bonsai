#!/bin/bash
GREEN='\033[0;32m'
LB='\033[1;34m' # light blue
NC='\033[0m' # No Color

MASTER=$(echo $(multipass list | grep master | awk '{print $1}'))
WORKERS=$(echo $(multipass list | grep worker | awk '{print $1}'))
NODES+=$MASTER
NODES+=" "
NODES+=$WORKERS

cleanupAnsw="y"
read -p  "Do you want to clean your /etc/hosts from multipass entries (y/n)?(default:y) promt with [ENTER]:" input
cleanupAnsw="${input:-$cleanupAnsw}"

if [ $cleanupAnsw == 'y' ];
then
  echo "We need to write the host entries on your local machine to /etc/hosts"
  echo "Please provide your sudo password:"

  # backup before cleanup
  cp /etc/hosts hosts.cleanup.backup
  cp hosts.cleanup.backup hosts

  # seach for existing multipass config
  exists=$(grep -n "####### multipass hosts start ##########" hosts | awk -F: '{print $1}' | head -1)
  # check if var is empty
  if test -z "$exists" 
  then
    exists=0
  fi

  # cut existing config
  if (("$exists" > "0")) ; then
    start=$(grep -n "####### multipass hosts start ##########" hosts | awk -F: '{print $1}' | head -1)
    ((start=start-1))
    end=$(grep -n "####### multipass hosts end   ##########" hosts | awk -F: '{print $1}' | head -1)
    sed -i '' ${start},${end}d hosts
  fi

  # cp cleaned hosts to /etc/hosts
  cp hosts /etc/hosts
fi

# Stop then delete nodes
for NODE in ${NODES}; do multipass stop ${NODE} && multipass delete ${NODE}; done
# Free discspace
multipass purge

rm hosts hosts.backup k3s.yaml.back k3s.yaml get_helm.sh  etchosts.unix 2> /dev/null
echo -e "[${GREEN}FINISHED${NC}]"
echo "############################################################################"
echo -e "[${LB}Info${NC}] Please cleanup the host entries in your /etc/hosts manually"
