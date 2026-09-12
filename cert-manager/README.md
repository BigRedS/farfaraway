# cert-manager

per-thing ingresses can just annotate `cert-manager.io/cluster-issuer: letsencrypt-prod`
and get a Let's Encrypt cert.


## Prerequisites (outside this repo)

* The DNS name for which the cert is being requested needs to resolve to this cluster
* Set LETSENCRYPT_EMAIL with the email address for LE notices 

## Deploy / upgrade

```sh
./install.sh          # installs/upgrades to the version in ./version
./install.sh v1.22.0  # installs/upgrades to that version, writes the versoin to ./version
./install.sh latest   # resolves cert-manager's actual latest release, writes it to ./version
```

No vendored manifest checked in — `cert-manager.yaml` is fetched straight
from `https://github.com/cert-manager/cert-manager/releases/download/<VERSION>/cert-manager.yaml`
each run, since it was already a plain `kubectl apply -f`, not something
farfaraway hand-authors. `VERSION` is the only file that needs editing to
pin/bump it manually; check cert-manager's own
[upgrade notes](https://cert-manager.io/docs/installation/upgrading/) before
jumping multiple versions.
