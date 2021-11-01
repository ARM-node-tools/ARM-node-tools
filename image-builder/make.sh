#!/bin/bash

# Internal script variables (no need to modify)
URL="https://cdimage.ubuntu.com/releases/20.04.2/release/ubuntu-20.04.2-preinstalled-server-arm64+raspi.img.xz"
XZ="ubuntu-20.04.2-preinstalled-server-arm64+raspi.img.xz"
ISO="ubuntu-20.04.2-preinstalled-server-arm64+raspi.img"

# Required config
pubKeyPath="sources/etc/skel/ethereum-server.pub"
googleAuthenticatorPath="sources/etc/skel/.google_authenticator"

# Optional config
imageName="arm_node_tools_solo_no_armbian_extras.img" # Customize the output image filename
DISTRIBUTED_PKGS="/tmp/ubuntu_iso/opt/arm_node_tools_dist_pkgs"

if [ -z "$pubKeyPath" ]; then
    echo "ERROR: \$pubKeyPath in make.sh is not set yet. Needs to point to a ED25519 or RSA public key"
    echo "You can generate one like this: ssh-keygen -t ed25519 -f $HOME/.ssh/ethereum-server"
    exit 1
fi

if [ ! -f "$pubKeyPath" ]; then
    echo "ERROR: \$pubKeyPath is actually set to '$pubKeyPath', but the file it is pointing to doesn't actually exist. Something is wrong here."
    exit 1
fi

if [ ! -f "$googleAuthenticatorPath" ]; then
    echo "WARNING: $googleAuthenticatorPath does not exist. Auto Google 2FA setup will be skipped on boot"
fi

mkdir -p /tmp/iso
[ ! -f "/tmp/iso/$XZ" ] && echo "Downloading base image..." && wget -P /tmp/iso $URL

echo "Making sure the downloaded image SHA256 hash is as expected"
# This works by taking the SHA256 hash of the compressed image and making sure the hash is exactly as expected
# You can verify this hash yourself by looking at SHA265SUMS in https://cdimage.ubuntu.com/releases/20.04.2/release/
# More details here: https://help.ubuntu.com/community/HowToSHA256SUM
sha256sum /tmp/iso/$XZ | grep 31884b07837099a5e819527af66848a9f4f92c1333e3ef0693d6d77af66d6832
if [[ ! $? -eq 0 ]]; then
    echo "WARNING: SHA256 hash failed. Base image may be corrupted or tampered with."
    exit 1
fi

[ ! -f "/tmp/iso/$ISO" ] && echo "Extracting base image" && unxz /tmp/iso/$XZ

rm -f /tmp/iso/dirty-$ISO # Delete any leftover dirty-$ISO (if any)
cp /tmp/iso/$ISO /tmp/iso/dirty-$ISO # Create a temporary copy of the ISO for mutation, to avoid tampering with the original

# Mount image
mkdir -p /tmp/ubuntu_iso
echo "Temporarily mounting base image locally for mutation" && sudo mount -o loop,offset=269484032 /tmp/iso/dirty-$ISO /tmp/ubuntu_iso

# Mutate image (this is how the sausage gets made)
sudo cp -a sources/* /tmp/ubuntu_iso # Copy rc.local script (this runs on every boot, and has a first run flag to run setup logic)
sudo mkdir -p $DISTRIBUTED_PKGS && sudo cp -R ./packages/*.deb $DISTRIBUTED_PKGS

# Unmount image and cleanup
echo "Unmounting base image and renaming it to '$imageName'" && sudo umount /tmp/ubuntu_iso
mv /tmp/iso/dirty-$ISO $imageName
rmdir /tmp/ubuntu_iso
