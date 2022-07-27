#!/bin/sh

## Steps needed before running anbox
## ---------------------------------
## These commands are generally harmless, that is, they do
## not have any effect on starting with standard kernel instead
## of linux-zen, and are therefore automated by some program

# 1. boot into linux-zen

# 2. modules: ashmem_linux and binder_linux are loaded by default by linux-zen

# 3. create /dev/binderfs *harmless* automated using /etc/tmpfiles.d
#mkdir /dev/bindfs

# 4. mount binder filsystem *harmless* automated using /etc/fstab
#mount -t binder none /dev/binderfs
mount /dev/binderfs

# 5. ensure android image is installed (e.g. AUR: anbox-image-gapps)

# 6. ensure anbox is installed and start it
systemctl start systemd-networkd.service  # for network access, from: https://wiki.archlinux.org/title/Anbox#Via_systemd-networkd
systemctl start anbox-container-manager.service
