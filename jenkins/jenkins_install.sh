#!/bin/bash
# Create Separate Namespace for Jenkins
kubectl create ns jenkins

# Create Persistent Volume for Jenkins
# testing pipeline again and
echo "apiVersion: v1
kind: PersistentVolume
metadata:
  name: jenkins-pv
  namespace: jenkins
  annotations:
    pv.beta.kubernetes.io/gid: "1000"
spec:
  storageClassName: jenkins-pv
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 4Gi
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /data/jenkins-volume/

---
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: jenkins-pv
provisioner: kubernetes.io/no-provisioner
volumeBindingMode: WaitForFirstConsumer" >~/jenkins-volume.yaml

sudo mkdir /data/jenkins -p
sudo chown -R 1000:1000 /data/jenkins
kubectl apply -f jenkins-volume.yaml

# Create Service Account for Jenkins
# curl https://raw.githubusercontent.com/jenkins-infra/jenkins.io/master/content/doc/tutorials/kubernetes/installing-jenkins-on-kubernetes/jenkins-sa.yaml >~/jenkins-sa.yaml
# kubectl apply -f jenkins-sa.yaml
# Create Configuration for Jenkins
curl https://raw.githubusercontent.com/KazikKluz/rsschool-devops/refs/heads/Task-4/jenkins/jenkins-values.yaml >~/jenkins-values.yaml

helm repo add jenkinsci https://charts.jenkins.io
helm repo update
helm search repo jenkinsci
chart=jenkinsci/jenkins
helm install jenkins -n jenkins -f jenkins-values.yaml $chart
