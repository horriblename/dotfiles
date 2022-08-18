#!/bin/sh
op=
case "$1" in
   off)   loc=1;;
   reboot)     loc=2;;
	lock)       loc=3;;
   logout)     loc=4;;
	*)	         loc=1;;
esac

shutdown=''
reboot='勒'
lock=''
logout=''

res=$(printf "$shutdown\n$reboot\n$lock\n$logout" | \
	wofi --dmenu --columns=4 --line=1
)

case "$res" in
	$shutdown) sudo /sbin/shutdown -P now;;
	$reboot) sudo reboot;;
	$logout) ~/.local/bin/swaysleep;;
	$lock) swaylock -f -i ~/Pictures/wallpapers/dwm_3.png;;
esac
