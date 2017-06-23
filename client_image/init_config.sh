#!/usr/bin/env bash

source "/data/kubernetes/env.sh"

init_token=`cat /data/kubernetes/init_token.metad`

while [ -z ${init_token} ]
do
      echo "sleep for wait init_token for 2 second"
      sleep 2
      init_token=`cat /data/kubernetes/init_token.metad`
done

echo "master ip: ${MASTER_IP} init_token: ${init_token}"

kubeadm client-config ${MASTER_IP} --token ${init_token} --skip-preflight-checks