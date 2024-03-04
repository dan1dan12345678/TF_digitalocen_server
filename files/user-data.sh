#!/bin/bash
apt-get update -y
apt-get install git -y

## Ip forwarding fix 
echo 'net.ipv4.ip_forward = 1' | tee -a /etc/sysctl.conf
modprobe br_netfilter
echo 'net.bridge.bridge-nf-call-iptables = 1' | sudo tee -a /etc/sysctl.conf
sysctl -p
swapoff -a

# Update the package index
sudo apt-get update

# Install prerequisites
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Set up the stable repository for Docker
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Update the package index again after adding Docker repo
sudo apt-get update

# Install Docker CE, Docker CE CLI, and containerd.io
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Ensure Docker service is unmasked, enabled, and started
sudo systemctl unmask docker
sudo systemctl enable docker
sudo systemctl start docker

# Verify Docker is running
sudo systemctl status docker --no-pager

# Since Docker and containerd are packaged together, you don't need to install containerd separately.
# The following steps are to configure containerd if needed for specific Kubernetes configurations.

# Generate the default containerd configuration file
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml > /dev/null

# Modify containerd configuration to use systemd as the cgroup driver
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# Restart and enable containerd to apply the configuration changes
sudo systemctl restart containerd
sudo systemctl enable containerd

# Verify containerd is running
sudo systemctl status containerd --no-pager


# install kubernetes 
sudo apt-get install -y apt-transport-https ca-certificates curl gpg software-properties-common
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
kubeadm config images pull

# start kubernetes
kubeadm init 
export KUBECONFIG=/etc/kubernetes/admin.conf










