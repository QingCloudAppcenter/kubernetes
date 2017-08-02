kubectl create configmap authorizedkeys --from-file=/root/.ssh/authorized_keys
#update
kubectl create configmap authorizedkeys --from-file=/root/.ssh/authorized_keys --dry-run -o yaml |kubectl replace -f -
