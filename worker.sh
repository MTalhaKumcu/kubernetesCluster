#!/bin/bash
sudo yum update -y
sudo mkdir logfile 
sudo echo "docker installing" >> /logfile/master.log
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo echo "kubernetes installing" >> /logfile/master.log
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
sudo echo "kubeadm installing" >> /logfile/master.log
sudo kubeadm init 
sudo kubectl get nodes >> /logfile/nodesMaster.log
watch kubectl get nodes >> /logfile/nodesMaster.log
sudo rm /etc/kubernetes/kubelet.conf
sudo rm /etc/kubernetes/pki/ca.crt
#sudo nano /etc/hosts
#10.0.1.199   ip-10-0-1-199.eu-north-1.compute.internal
sudo systemctl stop kubelet
sudo kill -9 $(sudo lsof -t -i:10250)