# feed-fiddler

Runs [BigRedS/feed-fiddler](https://github.com/BigRedS/feed-fiddler) — a podcast RSS feed
filterer/rewriter — as a daily CronJob, serving the generated feeds and a listing page from a
eVC via nginx.
`feeds.k8s.yaml` here is the real feed list — the same feeds/filters/fiddles as the upstream
repo's own `feeds.yaml`, but with `file` outputs instead of `s3` (see its header comment). Keep
it in sync by hand when the feed list changes upstream.

## Deploy

    kubectl apply -k .

Manually trigger the cronjob:

    kubectl create job feed-fiddler-manual-$(date +%s) --from=cronjob/feed-fiddler -n feed-fiddler
