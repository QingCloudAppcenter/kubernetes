#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

# if current host present in scala_in.info, mean destroy node, not destroy cluster.
if grep ${HOST_INSTANCE_ID} "/etc/kubernetes/scala_in.info"
then
    drain_node ${HOST_INSTANCE_ID}
    if [ $? -eq 1 ];
    then
        echo "drain node fail."
        exit 1
    fi
fi
kubectl delete node/${HOST_INSTANCE_ID}
echo "cleaner hostnic gateway nic"
niccleaner

