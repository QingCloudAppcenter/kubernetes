#!/usr/bin/env bash
if tar -cvzf /data/var/log/qingcloud-flex-volume/qingcloud-flex-volume-$(date +%Y-%m-%d).tar.gz /var/log/qingcloud-flex-volume/*.log.* &> /dev/null
then
  find /var/log/qingcloud-flex-volume -name "*.log.*" -print0|xargs -0 rm
  exit 0
fi
