#!/bin/sh

scripts_dir="${HOME}/scripts/chroot-tools"

function chrootwrap() {
	target=$1
	shell=$2
	mount -o bind "$target" "$target"

	export PATH="/bin:/sbin:/usr/bin:/usr/sbin"
	arch-chroot "$target" "$shell"
	umount "$target"
}

if [ ! -z "$1" ];then
   echo "args not supported yet..."
   exit
else
   printf "choose 1:\n"
   printf " 1: arch\n 2: alpine\n 3: debian\nYour Choice: "
   read ans
   case "$ans" in
      1)
         ${scripts_dir}/arch-chroot.sh "$HOME/Jail/arch"
         ;;
      2)
         sudo arch-chroot "$HOME/Jail/alpine" "/bin/ash"
         ;;
      3)
         sudo arch-chroot "$HOME/Jail/debian-stable" "/bin/bash"
         ;;
      *)
         printf "\nChoice not recognized"
         ;;
   esac
fi
