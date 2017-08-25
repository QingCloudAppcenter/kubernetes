#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

if systemctl is-active kubelet
then
    if [ "$(curl --silent --fail http://localhost:8080/healthz)" = "ok" ]
    then
        status=$(get_node_status)
        if [ "${status}" == "True" ]
        then
            exit 0
        fi
    fi
fi
exit 1