#!/usr/bin/env bash

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

echo "update logrotate"

cp -f ${K8S_HOME}/logrotate/conf /etc/logrotate.d/containerslog
cp -f ${K8S_HOME}/logrotate/docker-containers /etc/logrotate.d/docker-containers
cp -f ${K8S_HOME}/logrotate/cron /etc/cron.hourly/logrotate
