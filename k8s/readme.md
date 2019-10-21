# K8S

## Token Mgmt

Token Management
```
Get active tokens: kubeadm token list
Create Tokens: kubeadm token create

Get token ID
[root@k8smaster manifests]# openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl  rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
eae1f96ec2cf9424fcc85fd41753767ec017e0b8e4742d195bb81edb6ec4817f
```

## Common commands:
kubectl cluster-info

kubectl get nodes
kubectl describe nodes
kubectl get no --output wide
kubectl describe nodes node01

kubectl get pods
kubectl get pods --all-namespaces
kubectl get pods --namespace kube-system -o wide
kubectl describe pods --all-namespaces

kubectl get all --all-namespaces | more
kubectl api-resources | grep pod
kubectl explain pods
kubectl explain pods.spec.ephemeralContainers.image | more

kubectl run hello-world --image=gcr.io/google-samples/hello-app:1.0
kubectl run hello-world-pod --image=gcr.io/google-samples/hello-app:1.0 --generator=run-pod/v1

kubectl create deployment hello-world-pod --image=gcr.io/google-samples/hello-app:1.0

kubectl exec -it  hello-world-pod -- /bin/sh
kubectl describe deployment hello-world

kubectl expose deployment hello-world --port=80 --target-port=8080

kubectl get service hello-world
kubectl describe service hello-world

** At this point, you can hit it each pod directly if you like.

kubectl get service hello-world -o json --export > /tmp/dan2.txt

kubectl delete service hello-world
kubectl delete deployment hello-world
kubectl delete pods hello-world

~~~~~

Redeploy
[root@k8smaster tmp]# kubectl apply -f deployment.json
deployment.apps/hello-world created
[root@k8smaster tmp]# kubectl apply -f service.json
service/hello-world created
[root@k8smaster tmp]#

~~~~~

kubectl edit deploy hello-world

