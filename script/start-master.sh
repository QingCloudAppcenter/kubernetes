#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

ensure_dir

process_manifests

systemctl start docker
systemctl start kubelet
wait_kubelet
wait_apiserver
train_master