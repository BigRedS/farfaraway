#! /bin/bash
set -euo pipefail
cd "$(dirname "$0")"

kubectl apply -f _namespace.yaml

helm repo add traefik https://traefik.github.io/charts
helm repo update

helm upgrade --install traefik traefik/traefik \
  --namespace traefik \
  --values ./values.yaml
