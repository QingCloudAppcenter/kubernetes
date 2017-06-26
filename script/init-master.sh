#!/usr/bin/env bash
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

ensure_dir

init_token=$(get_or_gen_init_token)

kubeadm config --token ${init_token} --api-advertise-addresses ${HOST_IP} --skip-preflight-checks --api-external-dns-names ${ENV_API_EXTERNAL_DOMAIN}

# TODO wait static pod and addons up, and set label to master, and retain master node.
update_k8s_manifests

# start kubelet for node init join will connect to master.
systemctl start kubelet
wait_kubelet
