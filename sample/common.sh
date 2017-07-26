#!/usr/bin/env bash

while getopts e:v: option
do
 case "${option}"
 in
 e) EIP=${OPTARG};;
 v) VXNET=${OPTARG};;
 esac
done


function replace_vars(){
    local from=$1
    local name=$(basename ${from})
    local filename="${name%.*}"
    local to="$filename.yaml"
    sed 's/${EIP}/'"${EIP}"'/g' ${from} > "${to}"
    sed -i.bak 's/${VXNET}/'"${VXNET}"'/g' "${to}"
    rm "${to}.bak"
    echo ${to}
}

genpasswd() {
    local l=$1;
    [ "$l" == "" ] && l=16;
    LC_ALL=C  tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs ;
}

