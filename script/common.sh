#!/usr/bin/env bash
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "/data/kubernetes/env.sh"
source "${K8S_HOME}/version"

NODE_INIT_LOCK="/data/kubernetes/init.lock"

function mykubectl(){
    kubectl --kubeconfig='/etc/kubernetes/kubelet.conf' $*
}

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
    # update storage-class parameter according to the instance_class
    #TODO
    instance_class=$(qingcloud iaas describe-instances -i ${HOST_INSTANCE_ID} -f /etc/qingcloud/client.yaml |jq ".instance_set[0].instance_class")
    if [ ${instance_class} -eq 1 ]
    then
        VOLUME_TYPE=3
    else
        VOLUME_TYPE=0
    fi
    sed -i 's/${VOLUME_TYPE}/'"${VOLUME_TYPE}"'/g' /data/kubernetes/addons/qingcloud/qingcloud-storage-class.yaml
}

function join_node(){
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

function wait_apiserver(){
    while ! curl --output /dev/null --silent --fail http://localhost:8080/healthz;
    do
        echo "waiting k8s api server" && sleep 2
    done;
}

function wait_system_pod(){
    while [ "$(mykubectl get pods -o custom-columns=STATUS:.status.phase --no-headers=true -n kube-system|uniq)" != "Running" ]
    do
        echo "wait all kube-system pods running, no ready pods: "
        mykubectl get pods --no-headers=true -n kube-system |grep -v Running
        sleep 2
    done
}

function train_master(){
    mykubectl taint nodes ${HOST_INSTANCE_ID} dedicated=master:NoSchedule
}

function cordon_all(){
    for node in $(kubectl get nodes --no-headers=true -o custom-columns=name:.metadata.name)
    do
        mykubectl cordon $node
    done
}

function uncordon_all(){
    for node in $(kubectl get nodes --no-headers=true -o custom-columns=name:.metadata.name)
    do
        kubectl uncordon $node
    done
}

function clean_pod(){
    for namespace in $(mykubectl get namespaces --no-headers=true -o custom-columns=name:.metadata.name)
    do
        mykubectl delete $(mykubectl get pods --no-headers=true -o name -n ${namespace}) -n ${namespace}
    done
    while mykubectl get pods --no-headers=true --all-namespaces |grep Terminating
    do
        echo "wait all pods terminating:"
        mykubectl get pods --no-headers=true --all-namespaces |grep Terminating
        sleep 2
    done
}

function drain_node(){
    mykubectl drain --delete-local-data=true --ignore-daemonsets=true $1
    return $?
}

function link_dynamic_dir(){
    mkdir -p /data/var && mkdir /data/var/lib && mkdir /data/var/log
    mv /var/lib/docker /data/var/lib/
    ln -s /data/var/lib/docker /var/lib/docker
    mkdir /data/var/log/containers && ln -s /data/var/log/containers /var/log/containers
    mkdir /data/var/lib/kubelet && ln -s /data/var/lib/kubelet /var/lib/kubelet
}