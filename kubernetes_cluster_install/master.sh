#!/bin/bash

# Run this as root or with sudo: sudo ./master-setup.sh

set -euo pipefail

### VARIABLES ###
POD_CIDR="192.168.0.0/16"
K8S_VERSION="1.29"  # You can adjust as needed
CALICO_VERSION="v3.27.0"

echo "[INFO] Starting Kubernetes master setup..."

### STEP 1: Set hostname ###
echo "[INFO] Setting hostname to master-node"
hostnamectl set-hostname master-node

### STEP 2: Disable swap ###
echo "[INFO] Disabling swap"
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

### STEP 3: Install Docker ###
echo "[INFO] Installing Docker"
apt update
apt install -y docker.io
systemctl enable docker
systemctl start docker

### STEP 4: Install kubeadm, kubelet, kubectl ###
echo "[INFO] Installing Kubernetes components"
apt install -y apt-transport-https curl gnupg lsb-release

curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/kubernetes.gpg

cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt update
apt install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

### STEP 5: Initialize Kubernetes master ###
echo "[INFO] Initializing Kubernetes master with pod CIDR $POD_CIDR"
kubeadm init --pod-network-cidr="$POD_CIDR" --kubernetes-version="${K8S_VERSION}" || {
    echo "[ERROR] kubeadm init failed"
    exit 1
}

### STEP 6: Configure kubectl ###
echo "[INFO] Setting up kubeconfig"
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown "$(id -u)":"$(id -g)" $HOME/.kube/config

### STEP 7: Install Calico CNI ###
echo "[INFO] Installing Calico CNI plugin (version $CALICO_VERSION)"
kubectl apply -f "https://raw.githubusercontent.com/projectcalico/calico/${CALICO_VERSION}/manifests/calico.yaml"

### STEP 8: Wait for all system pods to be ready ###
echo "[INFO] Waiting for Kubernetes system pods to be ready..."
until kubectl get pods -n kube-system | grep -E 'kube-dns|calico' | grep -v Running; do
  sleep 5
  echo "[INFO] Waiting..."
done

echo "[SUCCESS] Master node setup complete!"

echo
echo "[NEXT STEP] Run the following command on your worker nodes to join the cluster:"
kubeadm token create --print-join-command
