# TF_digitalocen_server

#After creation add kubeconfig locally and manage from laptop your kurnetes node

terraform apply

ls -ls ./kubeconfig
# add from server to local kubernetes the kubeconfig 
cat ./kubeconfig
export KUBECONFIG=./kubeconf

# on master nodes run the join after creation

kubeadm token create --print-join-command > on master-node

# runt the outputs in remaining nodes but first reset the nodes and clean up
 1 kubeadm reset 
 2 kubeadm join XXX

 # eperminetal ELK added in docker-compose file under /files folder 
