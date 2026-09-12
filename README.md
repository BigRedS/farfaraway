# farfaraway

This is the config for my on-the-internet `farfaraway` cluster.

In contrast to duloc, it is running public-facing stuff; this is where most of
what is on https://cubanyetis.net (sounds like Kubernetes.net!) is or will be hosted.

Stuff on here ought to be stateless; it should be safe to blow this cluster away
and start again. State goes on databases or S3s or something.

Currently here:

* [Coralogix Quota Rules Status](https://coralogix-quota-rules-status.cubanyetis.net/): there isn't a good UI way of seeing the full status of your quota-rules in Coralogix, so here is a bad one
* [Coralogix Unused Metrics Finder](https://coralogix-unused-metrics-finder.cubanyetis.net/): find the metrics you send to Coralogix and never use. In practice, for any non-trivial-sized team this is too big for my noddy cluster and you want to [download the tool](https://github.com/BigRedS/coralogix-unused-metrics-finder) and run it locally. 
