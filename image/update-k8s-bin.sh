#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source ${K8S_HOME}/version

echo "update bin"

k8s_bins=("kubelet" "kubectl" "kubeadm")
k8s_base_url="https://pek3a.qingstor.com/k8s-qingcloud/k8s/${HYPERKUBE_VERSION}/bin"
k8s_bin_path="/usr/bin"

function download_k8s_bin()
{
    mkdir -p ${K8S_HOME}/bin
    pushd ${K8S_HOME}/bin
    rm *
    for bin in "${k8s_bins[@]}"; do
        local bin_url="$k8s_base_url/${bin}"
        echo "downloading ${bin_url}"
        wget ${bin_url}
        ln -fs "${K8S_HOME}/bin/${bin}"  "${k8s_bin_path}/${bin}"
    done
    wget "https://pek3a.qingstor.com/k8s-qingcloud/k8s/qingcloud/volume/qingcloud-flex-volume"
    chmod +x *
    ln -fs "${K8S_HOME}/bin/qingcloud-flex-volume"  "${k8s_bin_path}/qingcloud-flex-volume"
    "${K8S_HOME}/bin/qingcloud-flex-volume" --install=true
    popd
}

function download_flex_volume_driver()
{
    /usr/libexec/kubernetes/kubelet-plugins/volume/exec/
}

rm -rf ${K8S_HOME}/bin/*
download_k8s_bin

kubectl completion bash >/etc/profile.d/kubectl.sh
kubeadm completion bash >/etc/profile.d/kubeadm.sh
source /etc/profile