# ente-public-galleries

This is my hosting of my public-galleries frontend for ente:

https://github.com/BigRedS/ente-public-galleries

these docs are for my recollection of how I get the container in the right place,
see the readme in that project for instructions on what it is and how to use it.

# Updating:

    cd ~/repos/ente-public-galleries

First, verify the new albums are all public except the ones that need to stay private

    go build -o gallery-visibility ./cmd/gallery-visibility
    ./gallery-visibility -make-public '^\d{4}-\d{2}\s'
    ./gallery-visibility -make-private '^\d{4}-\d{2}\S'

Then generate the static site:

    go build -o ente-public-galleries .
    ./ente-public-galleries build

and build an image, tagging with today's date:

    podman login docker.io
    podman build --platform linux/amd64 -t bigreds/ente-galleries:20260918 .
    podman push bigreds/ente-galleries:20260918

finally, in this repo, update the deploy with the new tag and apply it

    vim deployment.yaml
    kubectl apply -k .
