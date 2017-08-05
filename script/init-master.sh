#!/usr/bin/env bash
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

ensure_dir
link_dynamic_dir

init_token=$(get_or_gen_init_token)
#retry kubeadm check --cloud-provider-name qingcloud --cloud-provider-config /etc/kubernetes/qingcloud.conf
kubeadm alpha phase certs selfsign --apiserver-advertise-address ${HOST_IP} --api-external-dns-names ${ENV_API_EXTERNAL_DOMAIN}
kubeadm alpha phase kubeconfig client-certs --client-name kubelet --server http://${MASTER_IP}:6443 > /etc/kubernetes/kubelet.conf
kubeadm alpha phase kubeconfig client-certs --client-name admin --server http://${MASTER_IP}:6443 > /etc/kubernetes/admin.conf
kubeadm token create ${init_token}
docker_login