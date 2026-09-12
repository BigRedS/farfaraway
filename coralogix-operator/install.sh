#! /bin/bash
set -euo pipefail
cd "$(dirname "$0")"

kubectl apply -f _namespace.yaml

if kubectl -n coralogix-operator get secret coralogix-operator >/dev/null 2>&1; then
  echo "coralogix-operator secret exists already, leaving it"
else
  if [ ! -f ./credentials.env ]; then
    echo "credentials.env missing; copy credentials.env.example to credentials.env and fill in CORALOGIX_API_KEY"
    exit 1
  fi
  source ./credentials.env
  if [ -z "${CORALOGIX_API_KEY:-}" ]; then
    echo "CORALOGIX_API_KEY unset in credentials.env; set it to continue"
    exit 1
  fi
  kubectl create --namespace coralogix-operator secret generic coralogix-operator \
    --from-literal=CORALOGIX_API_KEY="$CORALOGIX_API_KEY"
fi

helm repo add coralogix https://cgx.jfrog.io/artifactory/coralogix-charts-virtual
helm repo update

helm upgrade --install coralogix-operator coralogix/coralogix-operator \
  --namespace coralogix-operator \
  --values ./values.yaml
