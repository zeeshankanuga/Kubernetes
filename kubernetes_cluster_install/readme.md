# Kubernetes Cluster on AWS (Ubuntu EC2)

This repository helps you set up a basic Kubernetes cluster on AWS EC2 instances using `kubeadm` and the Calico CNI plugin.

## 📦 Requirements

- 1 Master + 1+ Worker EC2 instances (Ubuntu 20.04+)
- Security Group rules:
  - TCP: 22, 6443, 10250-10255, 30000-32767
  - UDP: 8472 (for Calico)
- Swap disabled
- Root or sudo privileges

## 🚀 Installation Steps

### 🔧 On Master Node

```bash
git clone https://github.com/zeeshankanuga/Kubernetes.git
cd Kubernetes/kubernetes_cluster_install
chmod +x master.sh
./master.sh
```
### 🔧 On Worker Node(s)
```
git clone https://github.com/zeeshankanuga/Kubernetes.git
cd Kubernetes/kubernetes_cluster_install
chmod +x worker-setup.sh
./worker-setup.sh
```
### ✅ Verification
```
kubectl get nodes
```
