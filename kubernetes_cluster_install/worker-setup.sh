#!/bin/bash

# Run on Ubuntu 20.04+ EC2 instance (Worker Node)

set -e

# Set hostname
hostnamectl set-hostname worker-node

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

echo "Worker node ready. Now run the 'kubeadm join' command from the master node to join this node to the cluster."
