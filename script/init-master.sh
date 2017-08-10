#!/usr/bin/env bash
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

ensure_dir
link_dynamic_dir

init_token=$(get_or_gen_init_token)
#retry kubeadm check --cloud-provider-name qingcloud --cloud-provider-config /etc/kubernetes/qingcloud.conf
kubeadm alpha phase certs selfsign --apiserver-advertise-address ${HOST_IP} --cert-altnames ${ENV_API_EXTERNAL_DOMAIN}
kubeadm alpha phase kubeconfig client-certs --client-name system:node:${HOST_INSTANCE_ID} --organization system:nodes --server https://${MASTER_IP}:6443 > /etc/kubernetes/kubelet.conf
kubeadm alpha phase kubeconfig client-certs --client-name system:kube-controller-manager --server https://${MASTER_IP}:6443 > /etc/kubernetes/controller-manager.conf
kubeadm alpha phase kubeconfig client-certs --client-name system:cloud-controller-manager --server https://${MASTER_IP}:6443 > /etc/kubernetes/cloud-controller-manager.conf
kubeadm alpha phase kubeconfig client-certs --client-name system:kube-scheduler --server https://${MASTER_IP}:6443 > /etc/kubernetes/scheduler.conf
kubeadm alpha phase kubeconfig client-certs --client-name kubernetes-admin --organization system:masters --server https://${MASTER_IP}:6443 > /etc/kubernetes/admin.conf
docker_login

process_manifests

systemctl start docker
systemctl start kubelet
wait_kubelet
wait_apiserver
train_master
retry kubeadm token create ${init_token} --token-ttl 0
