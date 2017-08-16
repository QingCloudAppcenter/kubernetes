#!/usr/bin/env bash

cat << EOF > /etc/sysctl.conf
net.ipv4.ip_forward = 1
vm.swappiness = 1
net.ipv4.conf.all.rp_filter = 2
vm.max_map_count=262144
fs.file-max=200000
fs.inotify.max_user_watches=1048576
EOF

sysctl -p

#only allow dhcp to manager eth0, not auto hotplug other interface.
cat << EOF > /etc/network/interfaces
auto lo
iface lo inet loopback

allow-hotplug eth0
iface eth0 inet dhcp
EOF

timedatectl set-timezone UTC