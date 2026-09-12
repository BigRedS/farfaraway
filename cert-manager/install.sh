#! /bin/bash
set -euo pipefail
cd "$(dirname "$0")"

# Usage: ./install.sh [version|latest]
#   ./install.sh          - installs/upgrades to the version in ./version
#   ./install.sh v1.22.0  - installs/upgrades to that version, and writes to ./version
#   ./install.sh latest   - resolves cert-manager's actual latest release, installs/upgrades to it, and writesit to ./version
VERSION="${1:-$(cat version)}"
if [ "$VERSION" = "latest" ]; then
  VERSION=$(curl -sL https://api.github.com/repos/cert-manager/cert-manager/releases/latest |
    grep -m1 '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
  echo "Resolved latest cert-manager release: $VERSION"
fi

if [ ! -f ./credentials.env ]; then
  echo "credentials.env missing; copy credentials.env.example to credentials.env and fill in LETSENCRYPT_EMAIL"
  exit 1
fi
source ./credentials.env
if [ -z "${LETSENCRYPT_EMAIL:-}" ]; then
  echo "LETSENCRYPT_EMAIL unset in credentials.env; set it to continue"
  exit 1
fi

echo "$VERSION" > version
kubectl apply -f "https://github.com/cert-manager/cert-manager/releases/download/${VERSION}/cert-manager.yaml"
kubectl wait --for=condition=Available deployment --all -n cert-manager --timeout=120s

export LETSENCRYPT_EMAIL
envsubst < clusterissuer.yaml | kubectl apply -f -
