#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

systemctl start docker
join_node

systemctl start kubelet
wait_kubelet
train_node
patch_flannel
#patch_cidr
