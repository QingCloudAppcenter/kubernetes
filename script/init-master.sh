#!/usr/bin/env bash
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

ensure_dir
link_dynamic_dir

systemctl start docker
docker_login

init_token=$(get_or_gen_init_token)
#retry kubeadm check --cloud-provider-name qingcloud --cloud-provider-config /etc/kubernetes/qingcloud.conf
kubeadm alpha phase certs all --apiserver-advertise-address ${MASTER_IP} --apiserver-cert-extra-sans ${ENV_API_EXTERNAL_DOMAIN} --service-cidr 10.96.0.0/16 --service-dns-domain cluster.local
kubeadm alpha phase kubeconfig all --apiserver-advertise-address ${MASTER_IP}

process_manifests

systemctl start kubelet
wait_kubelet
wait_apiserver

kubeadm alpha phase mark-master ${MASTER_INSTANCE_ID}
retry kubeadm token create ${init_token} --ttl 0 --description "the default kubeadm init token" --kubeconfig /etc/kubernetes/admin.conf
retry kubeadm alpha phase bootstrap-token node allow-post-csrs --kubeconfig /etc/kubernetes/admin.conf
retry kubeadm alpha phase bootstrap-token node allow-auto-approve --kubeconfig /etc/kubernetes/admin.conf
retry kubeadm alpha phase bootstrap-token cluster-info /etc/kubernetes/admin.conf --kubeconfig /etc/kubernetes/admin.conf
#retry kubeadm alpha phase upload-config --kubeconfig /etc/kubernetes/admin.conf
retry kubeadm alpha phase apiconfig --kubeconfig /etc/kubernetes/admin.conf
process_addons

