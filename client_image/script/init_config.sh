#!/usr/bin/env bash

source "/data/kubernetes/env.sh"

function fail {
  echo $1 >&2
  exit 1
}

function retry {
  local n=1
  local max=30
  local delay=10
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

init_token=`cat /data/kubernetes/init_token.metad`

while [ -z ${init_token} ]
do
      echo "sleep for wait init_token for 2 second"
      sleep 2
      init_token=`cat /data/kubernetes/init_token.metad`
done

echo "master ip: ${MASTER_IP} init_token: ${init_token}"
kubectl completion bash >>/etc/profile
retry kubeadm client-config ${MASTER_IP} --token ${init_token} --skip-preflight-checks
