#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

echo "install systemd config"

cp ${K8S_HOME}/systemd/* /etc/systemd/system/
systemctl daemon-reload
systemctl disable kubelet
systemctl disable docker

