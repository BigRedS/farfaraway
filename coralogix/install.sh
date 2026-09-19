#! /bin/bash
set -euo pipefail
cd "$(dirname "$0")"

if kubectl -n coralogix get secret coralogix-keys >/dev/null 2>&1; then
  echo "coralogix-keys secret exists already, leaving it"
else
  if [ -z "${CX_API_KEY:-}" ]; then
    echo "CX_API_KEY unset; set it (see .env) to continue"
    exit 1
  fi
  kubectl create namespace coralogix --dry-run=client -o yaml | kubectl apply -f -
  kubectl create --namespace coralogix secret generic coralogix-keys --from-literal=PRIVATE_KEY="$CX_API_KEY"
fi


helm repo add coralogix https://cgx.jfrog.io/artifactory/coralogix-charts-virtual
helm repo update


helm upgrade --install otel-coralogix-integration coralogix/otel-integration \
	--namespace coralogix \
	--create-namespace \
	--render-subchart-notes \
	--values ./values.yaml
