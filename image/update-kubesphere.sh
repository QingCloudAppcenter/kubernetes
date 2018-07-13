#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source ${K8S_HOME}/version

pushd /tmp
wget -c https://k8s-qingcloud.pek3a.qingstor.com/k8s/kubesphere/express-1.0.alpha/KubeInstaller-express-1.0.alpha.tar.gz
mkdir /opt/KubeInstaller-express-1.0.alpha
tar -zxvf KubeInstaller-express-1.0.alpha.tar.gz -C /opt/KubeInstaller-express-1.0.alpha
rm KubeInstaller-express-1.0.alpha.tar.gz

popd
