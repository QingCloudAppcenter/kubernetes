#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

echo "update bin"

k8s_bins=("kubelet" "kubectl" "kubeadm")
k8s_base_url="http://k8s-qingcloud.pek3a.qingstor.com/k8s/release/bin/linux/amd64"
k8s_bin_path="/usr/bin"

function download_k8s_bin()
{
    mkdir -p ${K8S_HOME}/bin
    pushd ${K8S_HOME}/bin
    for bin in "${k8s_bins[@]}"; do
        local bin_url="$k8s_base_url/${bin}"
        echo "downloading ${bin_url}"
        wget -c ${bin_url}
        unlink "${k8s_bin_path}/${bin}"
        ln -s "${K8S_HOME}/bin/${bin}"  "${k8s_bin_path}/${bin}"
    done
    chmod +x *
    popd
}

rm -rf ${K8S_HOME}/bin/*
download_k8s_bin

wget -c https://pek3a.qingstor.com/k8s-qingcloud/k8s/tool/nicleaner -O /usr/bin/niccleaner
chmod +x /usr/bin/niccleaner

pip install qingcloud-cli