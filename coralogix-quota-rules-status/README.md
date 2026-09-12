# coralogix-quota-rules-status

Web UI for [BigRedS/coralogix-quota-rules-status](https://github.com/BigRedS/coralogix-quota-rules-status),
a tool that reports on Coralogix TCO/quota rule usage against your plan.

Runs the published `webui` image (`ghcr.io/bigreds/coralogix-quota-rules-status-webui`,
public, no pull secret needed), pinned to `0.0.2-alpha`. No Coralogix secret
is configured here — you paste your own API key into the web form
per-request; the server is stateless and never writes to disk, so no volume
is needed either.

This repo also ships a separate `quota-rules-status-exporter` binary/image
meant for a cron-style metrics push to Coralogix — deliberately **not**
deployed here for now (it needs its own read-scoped API key and a
Send-Your-Data key as secrets). Add a `cronjob.yaml` + `Secret` here later if
that's wanted.

Requires `cert-manager` and its `letsencrypt-prod` ClusterIssuer to already
be installed (see `../cert-manager/`), plus a public DNS A record for
`coralogix-quota-rules-status.cubanyetis.net` pointed at this cluster —
adjust the hostname in `ingress.yaml` if you're using a different domain.

## Deploy

```sh
kubectl apply -k .
```
