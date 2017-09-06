#!/usr/bin/env bash

source ./common.sh

function usage(){
    echo "usage ./deploy-helloworld.sh -e eip-xxx"
    exit 1
}

if [ -z "${EIP}" ]
then
    usage
fi

yaml=$(replace_vars helloworld-web-deployment.tmpl)

kubectl apply -f ${yaml}
