#!/usr/bin/env bash

source ./common.sh

function usage(){
    echo "usage ./deploy-wordpress.sh -e eip-xxx"
    exit 1
}

if [ -z "${EIP}" ]
then
    usage
fi

echo -n $(genpasswd 10) > ./password.txt

kubectl create secret generic mysql-pass --from-file=password.txt

yaml=$(replace_vars wordpress-deployment.tmpl)

kubectl apply -f ${yaml}
