#!/usr/bin/env bash
if systemctl is-active kubelet
then
    if [ "$(curl --silent --fail http://localhost:8080/healthz)" = "ok" ]
    then
        exit 0
    fi
fi
exit 1