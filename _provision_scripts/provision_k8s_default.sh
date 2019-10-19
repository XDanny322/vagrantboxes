#!/bin/bash
########################################################################
# See https://www.howtoforge.com/tutorial/centos-kubernetes-docker-cluster/
#
#
# cmd that needs to be ran on the master AFTER setup
#   # Set netfilter
#   modprobe br_netfilter
#   echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables
#
#   kubeadm init --apiserver-advertise-address=192.168.56.141 --pod-network-cidr=192.168.0.0/16
#   # kubeadm init --apiserver-advertise-address=192.168.56.141 --pod-network-cidr=10.244.0.0/16
#
#   mkdir -p $HOME/.kube
#   sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
#   sudo chown $(id -u):$(id -g) $HOME/.kube/config
#
#   # https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
#
#   kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml
#   # kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/62e44c867a2846fefb68bd5f178daf4da3095ccb/Documentation/kube-flannel.yml
#
#   echo "
#   kind: Deployment
#   apiVersion: apps/v1beta1
#   metadata:
#     name: my-httpd
#   spec:
#     replicas: 2
#     template:
#       metadata:
#         labels:
#           app: webservers
#       spec:
#         containers:
#         - name: my-httpd-container1
#           image: httpd
#           ports:
#           - containerPort: 80
#   " > deploy.yml
#
#
#   echo "
#   kind: Service
#   apiVersion: v1
#   metadata:
#     name: my-httpd-service
#   spec:
#     selector:
#       app: webservers
#     type: LoadBalancer
#     externalIPs:
#     - 192.168.56.141
#     ports:
#       - name: my-apache-port
#         port: 8080
#         targetPort: 80
#   " > svc.yml

echo  "
192.168.56.141 k8smaster
192.168.56.142 node01
192.168.56.143 node02
" >> /etc/hosts

# Disable SE Linux
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

# Install docker and dependancy
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce

## Create /etc/docker directory.
mkdir /etc/docker

# Setup daemon.
# See https://kubernetes.io/docs/setup/production-environment/container-runtimes/
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}
EOF

# Install K8S
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
# gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
#         https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF

# Set netfilter
modprobe br_netfilter
echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables

# Turn off swap
swapoff -a
sed -i 's/\/swap/#\/swap/g' /etc/fstab

yum install -y kubelet kubeadm kubectl
systemctl start docker && systemctl enable docker
systemctl start kubelet && systemctl enable kubelet
