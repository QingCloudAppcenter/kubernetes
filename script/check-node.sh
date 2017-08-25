#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

if systemctl is-active kubelet
then
    status=$(get_node_status)
    if [ "${status}" == "True" ]
    then
        exit 0
    fi
fi
exit 1