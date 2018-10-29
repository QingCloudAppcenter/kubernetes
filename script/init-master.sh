#!/usr/bin/env bash
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

certificates=("/etc/kubernetes/pki/ca.crt" \ 
              "/etc/kubernetes/pki/ca.key" \
              "/etc/kubernetes/pki/sa.key" \
              "/etc/kubernetes/pki/sa.pub" \
              "/etc/kubernetes/pki/front-proxy-ca.crt" \
              "/etc/kubernetes/pki/front-proxy-ca.key" \
              "/etc/kubernetes/pki/etcd/ca.crt" \
              "/etc/kubernetes/pki/etcd/ca.key")

ensure_es
ensure_dir
link_dynamic_dir

systemctl start docker


init_token=$(get_or_gen_init_token)
#retry kubeadm check --cloud-provider-name qingcloud --cloud-provider-config /etc/kubernetes/qingcloud.conf
retry kubeadm alpha phase certs all --apiserver-advertise-address ${MASTER_IP} --apiserver-cert-extra-sans ${ENV_API_EXTERNAL_DOMAIN},$(join_by , ${MASTER_INSTANCE_IPS[@]}),$(join_by , ${MASTER_INSTANCE_IDS[@]}) --service-cidr 10.96.0.0/16 --service-dns-domain cluster.local
retry kubeadm alpha phase kubeconfig all --apiserver-advertise-address ${MASTER_IP}

# copy certificates from first master node
master_instance_id=${MASTER_INSTANCE_IDS[0]}
if [ $master_instance_id == $HOST_INSTANCE_ID ]
then
    ip addr add ${MASTER_IP}/24 dev eth0

  if [ $MASTER_COUNT == 3]
  then
    for certificate in "${certificates[@]}"
    do
      scp root@${master_instance_id}:${certificate} ${certificate}
    done
  fi
fi


process_manifests

systemctl start kubelet
wait_kubelet
wait_apiserver

# mark self as master
retry kubeadm alpha phase mark-master ${HOST_INSTANCE_ID}

if kubeadm token list|grep ${init_token}
then
  echo "token is existed, skip kubeadmin token creation"
else
  retry kubeadm token create ${init_token} --ttl 0 --description "the default kubeadm init token" --kubeconfig /etc/kubernetes/admin.conf
fi
retry kubeadm alpha phase bootstrap-token node allow-post-csrs --kubeconfig /etc/kubernetes/admin.conf
retry kubeadm alpha phase bootstrap-token node allow-auto-approve --kubeconfig /etc/kubernetes/admin.conf
retry kubeadm alpha phase bootstrap-token cluster-info /etc/kubernetes/admin.conf --kubeconfig /etc/kubernetes/admin.conf
#retry kubeadm alpha phase upload-config --kubeconfig /etc/kubernetes/admin.conf
#retry kubeadm alpha phase apiconfig --kubeconfig /etc/kubernetes/admin.conf
if kubectl get clusterrolebinding kubeadm:node-autoapprove-certificate-rotation
then
  echo "clusterrolebinding is existed, skip creatation"
else
  retry kubectl create clusterrolebinding kubeadm:node-autoapprove-certificate-rotation --clusterrole=system:certificates.k8s.io:certificatesigningrequests:selfnodeclient --group=system:nodes
fi
process_addons
