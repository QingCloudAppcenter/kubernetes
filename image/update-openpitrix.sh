#!/usr/bin/env bash
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source ${K8S_HOME}/version

echo "deploy openpitrix"

cd /tmp
curl -L https://git.io/GetOpenPitrix | OPENPITRIX_VERSION=v0.1.6 sh -
mv openpitrix-*-kubernetes /opt
