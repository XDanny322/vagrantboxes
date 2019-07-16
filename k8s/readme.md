# K8S

## Common commands:

Get Nodes:
```console
[root@k8smaster ~]# kubectl get nodes
NAME        STATUS   ROLES    AGE    VERSION
k8smaster   Ready    master   179m   v1.15.0
node01      Ready    <none>   171m   v1.15.0
node02      Ready    <none>   171m   v1.15.0
[root@k8smaster ~]#
```

Get status of all pods, including K8S.
``` console
[root@k8smaster ~]# kubectl get pods --all-namespaces
NAMESPACE     NAME                                READY   STATUS    RESTARTS   AGE
kube-system   coredns-5c98db65d4-8lw5g            1/1     Running   0          86s
kube-system   coredns-5c98db65d4-k7lzh            1/1     Running   0          86s
kube-system   etcd-k8smaster                      1/1     Running   0          18s
kube-system   kube-apiserver-k8smaster            1/1     Running   0          36s
kube-system   kube-controller-manager-k8smaster   1/1     Running   0          17s
kube-system   kube-flannel-ds-amd64-w87n2         1/1     Running   0          85s
kube-system   kube-proxy-66m4l                    1/1     Running   0          85s
kube-system   kube-scheduler-k8smaster            1/1     Running   0          22s
```

Get status of all pods, excluding K8S.
```console
[root@k8smaster ~]# kubectl get pods
No resources found.
[root@k8smaster ~]#
```

Run bash commands:
```console
[root@k8smaster ~]# kubectl exec -it my-httpd -- /bin/bash
root@my-httpd:/usr/local/apache2#
root@my-httpd:/usr/local/apache2# hostname -f
my-httpd
root@my-httpd:/usr/local/apache2# netstat
bash: netstat: command not found
root@my-httpd:/usr/local/apache2# ip addr
bash: ip: command not found
root@my-httpd:/usr/local/apache2# ipaddr
bash: ipaddr: command not found
root@my-httpd:/usr/local/apache2#
```

## Kube UI

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-beta1/aio/deploy/recommended.yaml
kubectl proxy --address='0.0.0.0' --disable-filter=false --accept-hosts='.*'
```

## Simply hello world http using direct cmds

```bash
[root@k8smaster ~]# kubectl run my-httpd --image=httpd --replicas=2 --port=80
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
deployment.apps/my-httpd created
[root@k8smaster ~]#
````



## Simply hello world nginx deployment using deploy file

See: https://kubernetes.io/docs/tasks/run-application/run-stateless-application-deployment/

First `wget https://k8s.io/examples/application/deployment.yaml`

Apply it:
```console
[root@k8smaster ~]# kubectl apply -f deployment.yaml
deployment.apps/nginx-deployment created
[root@k8smaster ~]#
[root@k8smaster ~]#
```

Check it status
```console
[root@k8smaster ~]# kubectl describe deployment nginx-deployment
Name:                   nginx-deployment
Namespace:              default
CreationTimestamp:      Mon, 15 Jul 2019 02:31:23 +0000
Labels:                 <none>
Annotations:            deployment.kubernetes.io/revision: 1
                        kubectl.kubernetes.io/last-applied-configuration:
                          {"apiVersion":"apps/v1","kind":"Deployment","metadata":{"annotations":{},"name":"nginx-deployment","namespace":"default"},"spec":{"replica...
Selector:               app=nginx
Replicas:               2 desired | 2 updated | 2 total | 0 available | 2 unavailable
StrategyType:           RollingUpdate
MinReadySeconds:        0
RollingUpdateStrategy:  25% max unavailable, 25% max surge
Pod Template:
  Labels:  app=nginx
  Containers:
   nginx:
    Image:        nginx:1.7.9
    Port:         80/TCP
    Host Port:    0/TCP
    Environment:  <none>
    Mounts:       <none>
  Volumes:        <none>
Conditions:
  Type           Status  Reason
  ----           ------  ------
  Available      False   MinimumReplicasUnavailable
  Progressing    True    ReplicaSetUpdated
OldReplicaSets:  <none>
NewReplicaSet:   nginx-deployment-5754944d6c (2/2 replicas created)
Events:
  Type    Reason             Age   From                   Message
  ----    ------             ----  ----                   -------
  Normal  ScalingReplicaSet  8s    deployment-controller  Scaled up replica set nginx-deployment-5754944d6c to 2
[root@k8smaster ~]#
```

Check whose running the pod
```console
[root@k8smaster ~]# kubectl get pods -l app=nginx
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-5754944d6c-vg6vm   1/1     Running   0          2m50s
nginx-deployment-5754944d6c-wt7dq   1/1     Running   0          2m50s
[root@k8smaster ~]# kubectl get pods
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-5754944d6c-vg6vm   1/1     Running   0          3m3s
nginx-deployment-5754944d6c-wt7dq   1/1     Running   0          3m3s
[root@k8smaster ~]#
```


Get one pod status
```console
[root@k8smaster ~]# kubectl describe pod  nginx-deployment-5754944d6c-vg6vm
Name:           nginx-deployment-5754944d6c-vg6vm
Namespace:      default
Priority:       0
Node:           node01/192.168.56.142
Start Time:     Mon, 15 Jul 2019 02:31:34 +0000
Labels:         app=nginx
                pod-template-hash=5754944d6c
Annotations:    <none>
Status:         Running
IP:             10.244.1.2
Controlled By:  ReplicaSet/nginx-deployment-5754944d6c
Containers:
  nginx:
    Container ID:   docker://e1b489542cc0e6d8b9e959f568ad9f00034492c292493873fbf3f8957d94e330
    Image:          nginx:1.7.9
    Image ID:       docker-pullable://nginx@sha256:e3456c851a152494c3e4ff5fcc26f240206abac0c9d794affb40e0714846c451
    Port:           80/TCP
    Host Port:      0/TCP
    State:          Running
      Started:      Mon, 15 Jul 2019 02:32:06 +0000
    Ready:          True
    Restart Count:  0
    Environment:    <none>
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from default-token-4wdm7 (ro)
Conditions:
  Type              Status
  Initialized       True
  Ready             True
  ContainersReady   True
  PodScheduled      True
Volumes:
  default-token-4wdm7:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-4wdm7
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  <none>
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                 node.kubernetes.io/unreachable:NoExecute for 300s
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  4m17s  default-scheduler  Successfully assigned default/nginx-deployment-5754944d6c-vg6vm to node01
  Normal  Pulling    4m5s   kubelet, node01    Pulling image "nginx:1.7.9"
  Normal  Pulled     3m34s  kubelet, node01    Successfully pulled image "nginx:1.7.9"
  Normal  Created    3m34s  kubelet, node01    Created container nginx
  Normal  Started    3m34s  kubelet, node01    Started container nginx
[root@k8smaster ~]#
```

Delete deploy
```console
[root@k8smaster ~]# kubectl delete deployment nginx-deployment
deployment.extensions "nginx-deployment" deleted
```

