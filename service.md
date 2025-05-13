# ✅ Why Services Are Needed
- Pods are dynamic: They can be restarted or rescheduled, changing their IP addresses.
- Services provide a stable virtual IP (ClusterIP) and DNS name that stays constant, even if the underlying Pods change.
---
- Load Balancing
- Service Discovery
- Exposing Application to external world
---
## 🛠️ How a Service Works
- Selector: A Service uses a label selector to identify the Pods it routes traffic to.
- ClusterIP: The Service gets a virtual IP address accessible inside the cluster.
- kube-proxy: Routes traffic sent to the Service IP to one of the selected Pods (load balanced).

## 🔧 Types of Services in Kubernetes

| **Type**       | **Purpose**                                                                                                                          | **Exposed To**              |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------ | --------------------------- |
| `ClusterIP`    | Default service type. Exposes the service on a virtual internal IP address. Accessible only within the cluster.                      | Inside the cluster          |
| `NodePort`     | Exposes the service on a static port (range: 30000–32767) on each node’s IP. You can access the service using `<NodeIP>:<NodePort>`. | External access via Node IP |
| `LoadBalancer` | Provisions an external IP address using a cloud provider’s load balancer. Routes traffic from the internet to your service.          | Public internet             |


### 📦 Example: ClusterIP Service
```
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: my-app           # Matches Pods with label app=my-app
  ports:
    - protocol: TCP
      port: 80            # Port exposed by the service
      targetPort: 8080    # Port the container listens on
```
