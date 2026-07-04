#!/bin/bash

set -ouex pipefail

# Copy the contents of system_files/ of the git repo to /
cp -avf "/ctx/system_files"/. /

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# PACKAGES=(
#     libcamera
# )

# dnf5 install -y "${PACKAGES[@]}"

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File
case "${IMAGE_VARIANT}" in
    # main)
    #     echo "Building main variant"
    #     # for now we don't need something special for the main variant
    #     ;;
    # nvidia)
    #     echo "Building NVIDIA variant"
    #     # for now we don't need something special for the nvidia variant
    #     ;;
    surface)
        echo "Building Surface variant"
        /ctx/surface-kernel.sh
        /ctx/finalize-surface.sh
        /ctx/image-cleanup.sh "${IMAGE_VARIANT}"
        ;;
    *)
        echo "Only 'surface' variant is supported right now"
        exit 1
        ;;
esac

# systemctl enable podman.socket || true
