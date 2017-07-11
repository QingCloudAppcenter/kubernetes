#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

if [ "${HOST_ROLE}" == "log" ]
then
    scale_es $((LOG_COUNT-1))
    process_es_config $((LOG_COUNT-1))
fi

for node in $(cat "/etc/kubernetes/scale_in.info")
do
    n=$(echo $node|tr '\n' ' ')
    if [ "$n" != "" ]
    then
        drain_node ${n}
        mykubectl delete node/${n}
    fi
done