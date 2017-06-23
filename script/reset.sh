#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

systemctl stop kubelet

echo "Unmounting directories in /var/lib/kubelet..."
cat /proc/mounts | awk '{print $2}' | grep '/var/lib/kubelet' | xargs umount

echo "clean config"
unlink /etc/kubernetes
rm /data/kubernetes/kubelet.conf
rm /data/kubernetes/admin.conf
rm /data/kubernetes/init_token
rm ${NODE_INIT_LOCK}
rm -rf /data/kubernetes/pki
rm -rf /data/kubernetes/manifests
rm -rf /data/kubernetes/addons

echo "stop all container"
docker ps -a | grep 'k8s_' | awk '{print $1}' | xargs docker rm --force --volumes

rm -rf /data/etcd

rm -rf /var/lib/kubelet/*

echo "flush iptables"
iptables --flush -t nat
iptables --flush

rm -rf /etc/cni 
