# 🔗 Relationship Overview
```
Deployment → manages → ReplicaSet → manages → Pod
```
## 📁 deployment.yaml — The Master Plan
- The Deployment is a high-level object that defines what your application should look like (e.g., container image, number of replicas).
- It’s what you write in your deployment.yaml file.
- It’s responsible for rolling updates, rollbacks, and scaling.

```
apiVersion: apps/v1
kind: Deployment
spec:
  replicas: 3
```
This tells Kubernetes: “I want 3 Pods of this application running at all times.”

## 🧬 ReplicaSet — The Enforcer
- A ReplicaSet is created by the Deployment.
- Its only job is to maintain the desired number of Pods running at any given time.
- It keeps checking: “Do I have 3 Pods? If not, create or remove some.”
Important: You usually don’t create ReplicaSets yourself — the Deployment does this for you.

## 🧪 Pod — The Workhorse
- A Pod is the smallest unit in Kubernetes and runs one or more containers.
- It contains your actual application code (in a container), for example: nginx, python, or node.

```
  containers:
      - name: my-app
        image: myusername/my-app:latest
```
This tells Kubernetes: “Run this Docker image as a container in each pod.”

### 🧠 Analogy
Think of it like a company:

- Deployment = CEO, defines the vision (e.g., we need 3 teams building the product).
- ReplicaSet = Manager, ensures there are 3 active teams (pods).
- Pod = Team doing the actual work (running your code).


# Kubernetes Deployment File

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80
```
