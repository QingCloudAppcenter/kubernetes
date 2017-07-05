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
    mkdir -p /data/es
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
    mkdir /data/kubernetes/manifests/ || rm -rf /data/kubernetes/manifests/*
    mkdir /data/kubernetes/addons/ || rm -rf /data/kubernetes/addons/*

    for f in ${K8S_HOME}/k8s/manifests/*; do
        name=$(basename ${f})
        replace_vars ${f} /data/kubernetes/manifests/${name}
    done

    for addon in ${K8S_HOME}/k8s/addons/*; do
        addon_name=$(basename $addon)
        mkdir /data/kubernetes/addons/${addon_name}
        for f in ${addon}/*; do
            name=$(basename ${f})
            replace_vars ${f} /data/kubernetes/addons/${addon_name}/${name}
        done
    done
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
    mykubectl taint nodes ${MASTER_INSTANCE_ID} --overwrite dedicated=master:NoSchedule
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
        mykubectl uncordon $node
    done
}

function clean_addons(){
    echo "stop addons-manager" && rm /data/kubernetes/manifests/kube-addon-manager.yaml && mykubectl delete "pods/kube-addon-manager-${MASTER_INSTANCE_ID}" -n kube-system
    mykubectl delete --force --grace-period=120 -R -f /data/kubernetes/addons/
    echo "clean addons" && rm -rf /data/kubernetes/addons
}

function clean_static_pod(){
    echo "clean static pod" && rm -rf /data/kubernetes/manifests
    while [ "$(docker ps -aq)" != "" ]
    do
        echo "wait all containers to be rm:"
        docker ps -a
        sleep 10
    done
}

function clean_pod(){
    clean_addons
    for namespace in $(mykubectl get namespaces --no-headers=true -o custom-columns=name:.metadata.name)
    do
        if [ "${namespace}" != "kube-system" ]
        then
            mykubectl delete --force --grace-period=120 --all pods -n ${namespace}
        fi
    done
    while mykubectl get pods --no-headers=true --all-namespaces |grep Terminating
    do
        echo "wait all pods terminating:"
        mykubectl get pods --no-headers=true --all-namespaces |grep Terminating
        sleep 5
    done
    clean_static_pod
}

function drain_node(){
    mykubectl drain --delete-local-data=true --ignore-daemonsets=true $1
    return $?
}

function link_dynamic_dir(){
    mkdir -p /data/var && mkdir /data/var/lib && mkdir /data/var/log
    mv /var/lib/docker /data/var/lib/
    ln -s /data/var/lib/docker /var/lib/docker
    mkdir /data/var/lib/kubelet && ln -s /data/var/lib/kubelet /var/lib/kubelet
}

function docker_stop_rm_all () {
    for i in `docker ps -q`
    do
        docker stop $i;
    done
    for i in `docker ps -aq`
    do
        docker rm $i;
    done
}

function flush_iptables(){
    iptables --flush -t nat
    iptables --flush
}
