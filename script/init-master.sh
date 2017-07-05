#!/usr/bin/env bash
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

ensure_dir
link_dynamic_dir

init_token=$(get_or_gen_init_token)

kubeadm config --token ${init_token} --api-advertise-addresses ${HOST_IP} --skip-preflight-checks --api-external-dns-names ${ENV_API_EXTERNAL_DOMAIN}