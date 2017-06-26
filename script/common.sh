#!/usr/bin/env bash
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "/data/kubernetes/env.sh"
source "${K8S_HOME}/version"

NODE_INIT_LOCK="/data/kubernetes/init.lock"

function ensure_dir(){
    mkdir -p /var/lib/kubelet
    mkdir -p /data/kubernetes
    if [ ! -L /etc/kubernetes ]; then
      ln -s /data/kubernetes /etc/kubernetes
    fi
}

function get_or_gen_init_token(){
    if [ -f "/data/kubernetes/init_token" ]; then
      init_token=$(cat /data/kubernetes/init_token)
    fi
    if [ -z  ${init_token}  ]; then
      init_token=$(kubeadm token generate)
      echo ${init_token} >/data/kubernetes/init_token
    fi
    echo ${init_token}
}

function replace_vars(){
    from=$1
    to=$2
    sed 's/${HYPERKUBE_VERSION}/'"${HYPERKUBE_VERSION}"'/g' ${from} >${to}
    echo "process ${from} to ${to}"
}

function update_k8s_manifests(){
    echo "echo update k8s manifests"
    mkdir -p /data/kubernetes
    mkdir /data/kubernetes/manifests/ || rm -rf /data/kubernetes/manifests/*
    mkdir /data/kubernetes/addons/ || rm -rf /data/kubernetes/addons/*

    for f in ${K8S_HOME}/k8s/manifests/*; do
        name=$(basename $f)
        replace_vars ${f} /data/kubernetes/manifests/${name}
    done

    for addon in ${K8S_HOME}/k8s/addons/*; do
        addon_name=$(basename $addon)
        mkdir /data/kubernetes/addons/${addon_name}
        for f in ${addon}/*; do
            name=$(basename $f)
            replace_vars ${f} /data/kubernetes/addons/${addon_name}/${name}
        done
    done
}

function init_node(){
    ensure_dir
    if [ -f "${NODE_INIT_LOCK}" ]; then
        echo "node has bean inited."
        return
    fi

    init_token=`cat /data/kubernetes/init_token.metad`
    while [ -z ${init_token} ]
    do
        echo "sleep for wait init_token for 2 second"
        sleep 2
        init_token=`cat /data/kubernetes/init_token.metad`
    done

    echo "master ip: ${MASTER_IP} init_token: ${init_token}"

    kubeadm join ${MASTER_IP} --token ${init_token} --skip-preflight-checks

    touch ${NODE_INIT_LOCK}
}

function wait_kubelet(){
    isactive=`systemctl is-active kubelet`
    while [ "${isactive}" != "active" ]
    do
        echo "kubelet is ${isactive}, waiting 2 seconds to be active."
        sleep 2
        isactive=`systemctl is-active kubelet`
    done
}