#!/bin/bash
sudo yum update -y
sudo echo "docker installing" >> ~/master.log
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo echo "kubernetes installing" >> ~/master.log
sudo cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.30/rpm/repodata/repomd.xml.key
exclude=kubelet kubeadm kubectl cri-tools kubernetes-cni
EOF
sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
sudo systemctl enable --now kubelet
yum repolist
sudo echo "kubeadm installing" >> ~/master.log
sudo kubeadm init