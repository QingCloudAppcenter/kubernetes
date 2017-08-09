#!/usr/bin/env bash
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "/data/kubernetes/env.sh"
source "${K8S_HOME}/version"

set -o errexit
set -o nounset
set -o pipefail

NODE_INIT_LOCK="/data/kubernetes/init.lock"

function fail {
  echo $1 >&2
  exit 1
}

function retry {
  local n=1
  local max=5
  local delay=5
  while true; do
    "$@" && break || {
      if [[ $n -lt $max ]]; then
        ((n++))
        echo "Command failed. Attempt $n/$max:"
        sleep $delay;
      else
        fail "The command has failed after $n attempts."
      fi
    }
  done
}

timestamp() {
  date +"%s"
}

function mykubectl(){
    kubectl --kubeconfig='/etc/kubernetes/kubelet.conf' $*
}

function ensure_dir(){
    if [ ! -d /root/.kube ]; then
        mkdir /root/.kube
    fi
    if [ ! -d /data/kubernetes ]; then
        mkdir -p /data/kubernetes
    fi
    if [ ! -d /data/es ]; then
        mkdir -p /data/es
    fi
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
    echo "process ${from} to ${to}"
    prefix=$(timestamp)
    name=$(basename ${from})
    tmpfile="/tmp/${prefix}-${name}"
    sed 's/${HYPERKUBE_VERSION}/'"${HYPERKUBE_VERSION}"'/g' ${from} > ${tmpfile}
    sed -i 's/${KUBE_LOG_LEVEL}/'"${ENV_KUBE_LOG_LEVEL}"'/g' ${tmpfile}
    sed -i 's/${HOST_IP}/'"${HOST_IP}"'/g' ${tmpfile}

    if [ "${to}" == "/data/kubernetes/addons/monitor/es-controller.yaml" ]
    then
        sed -i 's/replicas:\s./replicas: '"${LOG_COUNT}"'/g' ${tmpfile}
    fi

    diff ${tmpfile} ${to} >> /dev/null
    if [ "$?" -ne 0 ]
    then
        cp ${tmpfile} ${to}
        echo "${to} update"
    else
        echo "${to} in sync"
    fi
    rm ${tmpfile}
}

function update_k8s_manifests(){
    echo "echo update k8s manifests"
    #mkdir /data/kubernetes/manifests/ || rm -rf /data/kubernetes/manifests/*
    #mkdir /data/kubernetes/addons/ || rm -rf /data/kubernetes/addons/*
    process_manifests
}

function process_manifests(){
    mkdir -p /data/kubernetes/manifests/
    mkdir -p /data/kubernetes/addons/
    for f in ${K8S_HOME}/k8s/manifests/*; do
        name=$(basename ${f})
        replace_vars ${f} /data/kubernetes/manifests/${name}
    done

#    for addon in ${K8S_HOME}/k8s/addons/*; do
#        addon_name=$(basename $addon)
#        mkdir -p /data/kubernetes/addons/${addon_name}
#        for f in ${addon}/*; do
#            name=$(basename ${f})
#            replace_vars ${f} /data/kubernetes/addons/${addon_name}/${name}
#        done
#    done
}

function scale_es(){
    retry mykubectl scale --replicas=$1 statefulsets/elasticsearch-logging-v1 -n kube-system
}

function join_node(){
    ensure_dir
    if [ -f "${NODE_INIT_LOCK}" ]; then
        echo "node has bean inited."
        return
    fi

    local init_token=`cat /data/kubernetes/init_token.metad`
    while [ -z ${init_token} ]
    do
        echo "sleep for wait init_token for 2 second"
        sleep 2
        init_token=`cat /data/kubernetes/init_token.metad`
    done

    echo "master ip: ${MASTER_IP} init_token: ${init_token}"

    retry kubeadm join ${MASTER_IP}:6443 --token ${init_token} --skip-preflight-checks

    touch ${NODE_INIT_LOCK}
}

function wait_kubelet(){
    local isactive=`systemctl is-active kubelet`
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
    retry mykubectl taint nodes ${MASTER_INSTANCE_ID} --overwrite dedicated=master:NoSchedule
}

function train_node(){
    if [ "${HOST_ROLE}" == "log" ]
    then
        retry mykubectl taint nodes ${HOST_INSTANCE_ID} --overwrite dedicated=log:NoSchedule
    fi
}

function cordon_all(){
    for node in $(kubectl get nodes --no-headers=true -o custom-columns=name:.metadata.name)
    do
        mykubectl cordon $node
    done
}

function cordon_node(){
    mykubectl cordon ${HOST_INSTANCE_ID}
    return $?
}

function uncordon_all(){
    for node in $(kubectl get nodes --no-headers=true -o custom-columns=name:.metadata.name)
    do
        mykubectl uncordon $node
    done
}

function clean_addons(){
    echo "stop addons-manager" && rm /data/kubernetes/manifests/kube-addon-manager.yaml && mykubectl delete --ignore-not-found=true "pods/kube-addon-manager-${MASTER_INSTANCE_ID}" -n kube-system
    mykubectl delete --timeout=60s --force --now -R -f /data/kubernetes/addons/
    echo "clean addons" && rm -rf /data/kubernetes/addons
}

function clean_static_pod(){
    echo "clean static pod" && rm -rf /data/kubernetes/manifests
    sleep 10
    if [ "$(docker ps -aq)" != "" ]
    then
        echo "wait all containers to be rm:"
        docker ps -a
        sleep 10
    fi
}

function clean_pod(){
    clean_addons
    for namespace in $(mykubectl get namespaces --no-headers=true -o custom-columns=name:.metadata.name)
    do
        if [ "${namespace}" != "kube-system" ]
        then
            mykubectl delete --force --now --all --timeout=60s pods -n ${namespace}
        fi
    done
    local n=1
    local max=6
    while mykubectl get pods --no-headers=true --all-namespaces |grep Terminating
    do
        if [[ $n -lt $max ]]; then
            echo "break wait terminating."
            break
        fi
        echo "wait all pods terminating:"
        mykubectl get pods --no-headers=true --all-namespaces |grep Terminating
        sleep 5
        ((n++))
    done
    clean_static_pod
}

function drain_node(){
    mykubectl drain --delete-local-data=true --ignore-daemonsets=true --force $1
    return $?
}

function link_dynamic_dir(){
    mkdir -p /data/var && mkdir /data/var/lib && mkdir /data/var/log
    mv /var/lib/docker /data/var/lib/
    ln -s /data/var/lib/docker /var/lib/docker
    mkdir /data/var/lib/kubelet && ln -s /data/var/lib/kubelet /var/lib/kubelet
    ln -s /root/.docker /data/var/lib/kubelet/.docker
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

function wait_qingcloudvolume_detach(){
    while df |grep "qingcloud-volume" > /dev/null;
    do
        echo "waiting qingcloud-volume detach" && df |grep "qingcloud-volume" && sleep 2
    done
}

function docker_login(){
    if [ ! -z "${DOCKERHUB_USERNAME}" ] && [ ! -z "${DOCKERHUB_PASSWORD}" ]
    then
        retry docker login dockerhub.qingcloud.com -u ${DOCKERHUB_USERNAME} -p ${DOCKERHUB_PASSWORD}
    fi
}

function upgrade_docker(){
    #clear old aufs
    rm -rf /data/var/lib/docker/aufs
    rm -rf /data/var/lib/docker/image
    #copy overlays2
    mv /var/lib/docker/image /data/var/lib/docker/
    mv /var/lib/docker/overlay2 /data/var/lib/docker/
    rm -rf /var/lib/docker
    ln -s /data/var/lib/docker /var/lib/docker
    ln -s /data/var/lib/kubelet /var/lib/kubelet
    return 0
}