#!/bin/bash

set -euxo pipefail

IMAGE_VARIANT="$1"
test -n "$IMAGE_VARIANT"

# Cleanup
KVER="$(find /usr/lib/modules -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | grep "$IMAGE_VARIANT" | head -n1)"

test -n "$KVER"
test -s "/usr/lib/modules/${KVER}/vmlinuz"
test -s "/usr/lib/modules/${KVER}/initramfs.img"

# Thanks shellcheck, but we're deleting a system directory on purpose here
# shellcheck disable=SC2114
rm -rf "/boot/*"
rm -rf /tmp/packages /run/dnf /var/lib/dnf /var/cache/dnf /var/lib/rpm-state
dnf5 clean all || true
rm -rf /var/cache/* /var/log/*
