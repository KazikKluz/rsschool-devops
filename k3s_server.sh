#!/bin/bash

#yum install selinux-policy-targeted -y

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" K3S_TOKEN=${token} sh -s -

# kubeconfig  non-root access
sudo ln -s /usr/local/bin/k3s /usr/bin/k3s
sudo mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chmod 777 ~/.kube/config
echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc
source ~/.bashrc
