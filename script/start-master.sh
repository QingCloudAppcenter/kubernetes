#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

ensure_dir

update_k8s_manifests

systemctl start docker
systemctl start kubelet
wait_kubelet
wait_apiserver
wait_system_pod
train_master
uncordon_all