#!/usr/bin/env bash
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

ensure_dir
link_dynamic_dir
systemctl start docker

#auto upgrade, just for test
#TODO remove for production,
echo "update git"
cd ${K8S_HOME}
git pull origin master
${K8S_HOME}/image/update-confd.sh
${K8S_HOME}/image/update-bin.sh
${K8S_HOME}/image/pull-images.sh

init_token=$(get_or_gen_init_token)

kubeadm config --token ${init_token} --api-advertise-addresses ${HOST_IP} --skip-preflight-checks --api-external-dns-names ${ENV_API_EXTERNAL_DOMAIN}

update_k8s_manifests

# start kubelet for node init join will connect to master.
systemctl start kubelet
wait_kubelet
wait_apiserver
wait_system_pod
train_master
