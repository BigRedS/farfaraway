# traefik

Self-managed replacement for k3s's bundled Traefik+ServiceLB, disabled on
donkey via ansible's `k3s_disable` (see the `ansible` repo's
`roles/k3s/defaults/main.yaml`).

ServiceLB claims a Service's `hostPort` with no `hostIP` set, which binds
*both* address families on the node regardless of the Service's own
`ipFamilies` restriction - there's no annotation or flag to scope it to one
family (checked against k3s's own `servicelb.go` source). That conflicted
with apache owning ports 80/443 on donkey's ipv4 address. This chart's
`ports.*.hostIP` fields fix it properly - they're read generically per-port
by the chart's own template, and actually restrict the bind to one address.

`ingressClassName: traefik` on existing Ingress objects (feed-fiddler,
coralogix-quota-rules-status, coralogix-unused-metrics-finder) needed no
changes - this release creates an IngressClass of the same name.

## Deploy

```sh
./install.sh
```

## Verify

```sh
kubectl -n traefik get pods
kubectl get ingressclass
```

Then from outside the cluster: `curl -6 https://feed-fiddler.cubanyetis.net/`
(or any of the other Ingress hostnames) should succeed, and on donkey itself
`ss -tln` should show apache still holding `0.0.0.0:80`/`:443` on ipv4
without contention.
