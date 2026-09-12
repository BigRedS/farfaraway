# coralogix-operator

The [Coralogix Kubernetes Operator](https://github.com/coralogix/coralogix-operator)

used here as something to play with, installed via script to copy the docs.

## Prerequisites

1. A Coralogix **API key** (Settings → Users and Teams → API Keys) with
   permission presets for whichever resource kinds you intend to manage
2. `CORALOGIX_API_KEY` in  `credentials.env`
3. `coralogixOperator.region` in `values.yaml` if that's wrong.

## Deploy

```sh
./install.sh
```

## Verify

```sh
kubectl -n coralogix-operator get pods
kubectl -n coralogix-operator logs deploy/coralogix-operator-controller-manager
```

Logs should show a successful connection to `eu2.coralogix.com` with no auth
errors. As a smoke test, apply one of the operator's own sample CRs, e.g. the
trivial recording-rule example from
[config/samples/v1alpha1/recordingrulegroupset](https://github.com/coralogix/coralogix-operator/blob/main/config/samples/v1alpha1/recordingrulegroupset/coralogix_v1alpha1_recordingrulegroupset.yaml):

```yaml
apiVersion: coralogix.com/v1alpha1
kind: RecordingRuleGroupSet
metadata:
  name: smoke-test
  namespace: coralogix-operator
spec:
  groups:
    - name: smoke-test.rules
      intervalSeconds: 60
      rules:
        - expr: vector(1)
          record: SmokeTest
```

```sh
kubectl apply -f - <<'EOF'
# (paste the above)
EOF
kubectl -n coralogix-operator get recordingrulegroupset smoke-test -o yaml   # check status has no error
kubectl -n coralogix-operator delete recordingrulegroupset smoke-test
```
