#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

ensure_dir

systemctl start docker
systemctl start kubelet
wait_kubelet
wait_apiserver
clean_heapster140
#patch_cidr