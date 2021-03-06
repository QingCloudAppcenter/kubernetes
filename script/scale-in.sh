#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

for node in $(cat "/etc/kubernetes/scale_in.info")
do
    n=$(echo $node|tr '\n' ' ')
    if [ "$n" != "" ]
    then
        drain_node ${n}
        mykubectl delete node/${n}
    fi
done
exit 0