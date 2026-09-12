# coralogix-unused-metrics-finder

Web UI for [BigRedS/coralogix-unused-metrics-finder](https://github.com/BigRedS/coralogix-unused-metrics-finder),
a tool that scans a Coralogix account for metrics that aren't queried
anywhere (dashboards/alerts/etc.) so they can be dropped to cut cost.

Runs the published `webui` image (`ghcr.io/bigreds/coralogix-unused-metrics-finder-webui`,
public, no pull secret needed), pinned to `0.0.5`. No Coralogix secret is
configured here — you paste your own API key into the web form per scan; it
never touches the cluster's config at rest. The container runs read-only
with an `emptyDir` at `/tmp` since a scan writes its report there before
you download it, and the volume (and any report in it) disappears when the
pod restarts, by design.

Requires `cert-manager` and its `letsencrypt-prod` ClusterIssuer to already
be installed (see `../cert-manager/`), plus a public DNS A record for
`coralogix-unused-metrics-finder.cubanyetis.net` pointed at this cluster —
adjust the hostname in `ingress.yaml` if you're using a different domain.

## Deploy

```sh
kubectl apply -k .
```
