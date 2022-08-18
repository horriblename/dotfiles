#!/bin/sh

chroot_dir="$1"
shift
shell_command=$*

echo "mounting jail..."
sudo mount --bind "$chroot_dir" "$chroot_dir"

export GTK_THEME=Adwaita:dark # temporary fix for applying gtk dark themes

sudo arch-chroot "$chroot_dir" "$shell_command"

echo "unmounting jail..."
sudo umount -R "$chroot_dir"
