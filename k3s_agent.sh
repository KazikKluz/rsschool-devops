#!/bin/bash

# yum install selinux-policy-targeted -y

curl -sfL https://get.k3s.io | K3S_URL="https://${server_addr}:6443" K3S_TOKEN=${token} sh -s -
