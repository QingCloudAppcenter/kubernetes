#!/usr/bin/env bash
if tar -cvzf /data/var/log/qingcloud-flex-volume-controller-manager/qingcloud-flex-volume-controller-manager-$(date +%Y-%m-%d).tar.gz /var/log/qingcloud-flex-volume-controller-manager/*.log.* &> /dev/null
then
  find /var/log/qingcloud-flex-volume-controller-manager -name "*.log.*" -print0|xargs -0 rm
  exit 0
fi
