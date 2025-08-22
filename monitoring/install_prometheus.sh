#!/bin/bash

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm upgrade --install prometheus bitnami/kube-prometheus \
	-n monitoring \
	--create-namespace \
	-f "${SCRIPT_DIR}/values-prometheus.yaml"

echo "✅ Prometheus deployment triggered via Helm."
