#!/usr/bin/env bash

systemctl is-active docker >/dev/null 2>&1 && systemctl restart docker