#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source ${K8S_HOME}/version

echo "update images"

docker login -u guest -p guest dockerhub.qingcloud.com

docker pull dockerhub.qingcloud.com/google_containers/pause-amd64:3.0
docker pull dockerhub.qingcloud.com/google_containers/etcd-amd64:3.0.17
docker pull dockerhub.qingcloud.com/google_containers/hyperkube-amd64:${HYPERKUBE_VERSION}
docker pull dockerhub.qingcloud.com/google_containers/k8s-dns-kube-dns-amd64:1.14.4
docker pull dockerhub.qingcloud.com/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.4
docker pull dockerhub.qingcloud.com/google_containers/k8s-dns-sidecar-amd64:1.14.4
docker pull dockerhub.qingcloud.com/google_containers/kube-addon-manager:v6.4-beta.2
#docker pull dockerhub.qingcloud.com/coreos/flannel:v0.7.0-amd64
docker pull dockerhub.qingcloud.com/google_containers/kubernetes-dashboard-amd64:v1.6.1
docker pull dockerhub.qingcloud.com/fluent/fluent-bit-kubernetes-daemonset:0.11.13
docker pull dockerhub.qingcloud.com/google_containers/heapster-amd64:v1.4.0
docker pull dockerhub.qingcloud.com/google_containers/addon-resizer:1.7
docker pull dockerhub.qingcloud.com/google_containers/kibana:v5.4.0
docker pull dockerhub.qingcloud.com/google_containers/elasticsearch:v5.4.0-1
docker pull dockerhub.qingcloud.com/qingcloud/elasticsearch-curator:5.1.1
docker pull dockerhub.qingcloud.com/qingcloud/file-sync:0.7