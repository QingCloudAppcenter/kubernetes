#!/usr/bin/env bash

sed -i 's/net.ipv4.conf.all.rp_filter = 2/net.ipv4.conf.all.rp_filter = 0/g' /etc/sysctl.conf
sysctl -p


