#!/usr/bin/env bash

systemctl is-active kubelet >/dev/null 2>&1 && systemctl restart kubelet