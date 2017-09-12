#!/usr/bin/env bash
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

ensure_dir
link_dynamic_dir
#retry kubeadm check --cloud-provider-name qingcloud --cloud-provider-config /etc/kubernetes/qingcloud.conf
docker_login