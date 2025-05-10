# 📦 Kubernetes Architecture: Complete Guide
Kubernetes (also known as K8s) is a powerful container orchestration system for automating deployment, scaling, and management of containerized applications. Understanding its architecture is crucial to mastering how it operates and how it manages workloads across distributed systems.

![image](https://github.com/user-attachments/assets/53b3630c-5ab7-48ba-88ae-394bba048384)

## 🧭 Overview
Kubernetes architecture follows a client-server model with a Control Plane (Master Node) that manages the cluster, and Worker Nodes that run containerized applications.
### 🔧 Key Components
- Control Plane (Master Components)
- Worker Nodes (Node Components)
- Cluster Store (etcd)

## 📌 1 Control Plane Components

The Control Plane manages the Kubernetes cluster, making global decisions and detecting/responding to cluster events.

### 1.1. kube-apiserver
- Acts as the front-end (REST API) for the Kubernetes Control Plane.
- All communication between components and external clients goes through it.
- Validates and processes REST requests, then updates etcd.

### 1.2. etcd
- A distributed key-value store used as Kubernetes' backing store.
- Stores the entire state of the cluster (e.g., configurations, secrets, nodes).
- Highly available and strongly consistent.

### 1.3. kube-scheduler
- Watches for newly created Pods that don’t have a node assigned.
- Selects the best node for the pod to run on based on resource requirements, affinity, taints, etc.

### 1.4. kube-controller-manager
Runs controller processes:
- Node Controller: Watches nodes and manages availability.
- Replication Controller: Ensures correct number of pods.
- Endpoints Controller: Manages service/pod mapping.
- Service Account & Token Controllers.

### 1.5. cloud-controller-manager
- Interacts with the underlying cloud provider (if used).
- Handles tasks like node provisioning, route setup, and load balancing.

## ⚙️ 2. Node (Worker Node) Components

Worker Nodes are physical or virtual machines where your application pods run.

### 2.1. kubelet
- An agent that runs on each node.
- Ensures containers are running as defined in PodSpecs.
- Communicates with the kube-apiserver.

### 2.2. kube-proxy
- Maintains network rules on nodes.
- Handles traffic routing to the correct Pods across the cluster using iptables or IPVS.

### 2.3. Container Runtime
- Software responsible for running containers (e.g., containerd, CRI-O, Docker).
- Interfaces with kubelet via the Container Runtime Interface (CRI).

## 🔄 Kubernetes Workflow
Here's how everything ties together:
- User submits a request (e.g., deploy a Pod) to kube-apiserver.
- kube-apiserver authenticates, validates, and stores the request in etcd.
- kube-scheduler finds a suitable node for the Pod.
- kubelet on the selected node pulls the container image and runs the Pod.
- kube-proxy ensures the Pod is reachable within the network.


✅ Summary

| **Component**            | **Role**                                               |
|--------------------------|--------------------------------------------------------|
| `kube-apiserver`         | API gateway for all cluster operations                 |
| `etcd`                   | Persistent storage for cluster state                   |
| `kube-scheduler`         | Schedules Pods to Nodes                                |
| `kube-controller-manager`| Runs background reconciliation loops                   |
| `kubelet`                | Manages pod execution on each worker node              |
| `kube-proxy`             | Handles pod networking                                 |
| `container runtime`      | Runs containers                                        |
