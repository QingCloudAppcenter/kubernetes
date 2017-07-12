#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

systemctl is-active kubelet >/dev/null 2>&1 && {
    if [ "${HOST_ROLE}" == "master" ]
    then
        kubectl delete -f /etc/kubernetes/addons/qingcloud/clean-log-job.yaml
        kubectl create -f /etc/kubernetes/addons/qingcloud/clean-log-job.yaml
    fi
}

