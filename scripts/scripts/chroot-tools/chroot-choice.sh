#!/bin/sh

scripts_dir="${HOME}/scripts/chroot-tools"

if [ ! -z "$1" ];then
   echo "args not supported yet..."
   exit
else
   printf "choose 1:\n"
   printf " 1: arch\n 2: alpine\n 3: debian\nYour Choice: "
   read ans
   case "$ans" in
      1)
         ${scripts_dir}/arch-chroot.sh "$HOME/jail/arch"
         ;;
      2)
         sudo ${scripts_dir}/chroot-wrap.sh "$HOME/jail/alpine" "/bin/ash"
         ;;
      3)
         sudo ${scripts_dir}/chroot-wrap.sh "$HOME/jail/debian-stable" "/bin/bash"
         ;;
      *)
         printf "\nChoice not recognized"
         ;;
   esac
fi
