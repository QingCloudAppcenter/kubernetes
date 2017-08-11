#!/usr/bin/env bash
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

ensure_dir

init_token=$(get_or_gen_init_token)
adminconf=$(cat "/etc/kubernetes/admin.conf")
echo '{"init_token":"'${init_token}'", "adminconf":'${adminconf}'}'
