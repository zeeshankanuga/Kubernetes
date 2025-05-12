#!/bin/bash

# Run this as root or with sudo: sudo ./master-setup.sh

set -euo pipefail

### VARIABLES ###
POD_CIDR="192.168.0.0/16"
K8S_VERSION="1.32"  # You can adjust as needed
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
#These instructions are for Kubernetes v1.32.
#Update the apt package index and install packages needed to use the Kubernetes apt repository:

sudo apt-get update
# apt-transport-https may be a dummy package; if so, you can skip that package
sudo apt-get install -y apt-transport-https ca-certificates curl gpg

#Download the public signing key for the Kubernetes package repositories. The same signing key is used for all repositories so you can disregard the version in the URL:

# If the directory `/etc/apt/keyrings` does not exist, it should be created before the curl command, read the note below.
# sudo mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

#Add the appropriate Kubernetes apt repository. Please note that this repository have packages only for Kubernetes 1.32; for other Kubernetes minor versions, you need to change the Kubernetes minor version in the URL to match your desired minor version (you should also check that you are reading the documentation for the version of Kubernetes that you plan to install).

# This overwrites any existing configuration in /etc/apt/sources.list.d/kubernetes.list
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

#Update the apt package index, install kubelet, kubeadm and kubectl, and pin their version:

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

sudo systemctl enable kubelet

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
