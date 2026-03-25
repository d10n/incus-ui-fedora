#!/bin/bash

podman build -t rpm-builder -f rpm-builder.Containerfile .
podman build -t incus-ui-builder -f incus-ui-builder.Containerfile .

mkdir -p SOURCES SPECS OUTPUT BUILD

podman_run=(
  podman run
    --rm
    --userns=keep-id
    -v ./SOURCES:/rpmbuild/SOURCES:Z
    -v ./SPECS:/rpmbuild/SPECS:Z
    -v ./OUTPUT:/rpmbuild/OUTPUT:Z
    -v ./BUILD:/rpmbuild/BUILD:Z
    localhost/incus-ui-builder
)

# Download sources
"${podman_run[@]}" spectool -g -R /rpmbuild/SPECS/incus-ui.spec
# Build
"${podman_run[@]}" rpmbuild -bb /rpmbuild/SPECS/incus-ui.spec
