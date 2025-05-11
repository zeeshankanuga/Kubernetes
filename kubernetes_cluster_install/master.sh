#!/bin/bash

# Run on Ubuntu 20.04+ EC2 instance (Master Node)

set -e

# Set hostname
hostnamectl set-hostname master-node

# Disable swap
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# Install container runtime
apt update
apt install -y docker.io
systemctl enable docker
systemctl start docker

# Install kubeadm, kubelet, kubectl
apt update && apt install -y apt-transport-https curl
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt update
apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# Init Kubernetes master with Calico's default pod CIDR
kubeadm init --pod-network-cidr=192.168.0.0/16

# Setup kubeconfig for current user
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Install Calico CNI
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

echo "Master node setup complete. Copy the 'kubeadm join' command below and run it on your worker nodes."
