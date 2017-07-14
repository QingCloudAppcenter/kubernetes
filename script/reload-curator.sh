#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

systemctl is-active kubelet >/dev/null 2>&1 && {
    if [ "${HOST_ROLE}" == "master" ]
    then
        JOB_ID=$(timestamp)
        sed 's/${JOB_ID}/'"${JOB_ID}"'/g' /etc/kubernetes/addons/qingcloud/clean-log-job.yaml > /tmp/clean-log-job-${JOB_ID}.yaml
        retry mykubectl create -f /tmp/clean-log-job-${JOB_ID}.yaml
        rm /tmp/clean-log-job-${JOB_ID}.yaml
    fi
}

