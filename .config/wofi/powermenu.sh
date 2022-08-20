#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3
## source: https://github.com/archcraft-os/archcraft-dwm/blob/main/archcraft-dwm/shared/wofi/bin/powermenu

#DIR="/usr/share/archcraft/dwm"
DIR="$XDG_CONFIG_HOME"

wofi_command="wofi -theme $DIR/wofi/themes/powermenu.rasi"
uptime=$(uptime -p | sed -e 's/up //g')
lockcmd='swaylock -f'

# Options
shutdown=''
reboot='勒'
lock=''
suspend="⏾"
logout=''

# Get user confirmation 
get_confirmation() {
	wofi --dmenu -i \
		 --columns=2 --line=1 \
		 --prompt "Are You Sure? : " \
		 #-theme "$DIR"/wofi/themes/confirm.rasi
}

# Show message
show_msg() {
	wofi -e "Options  -  yes / y / no / n"
}

# Variable passed to wofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"

chosen="$(echo -e "$options" | $wofi_command -p "UP - $uptime" --dmenu \
	--columns=5 --line=1 --halign=center)"
case $chosen in
    $shutdown)
		ans=$(get_confirmation &)
		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
			systemctl poweroff
		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
			exit
        else
			show_msg
        fi
        ;;
    $reboot)
		ans=$(get_confirmation &)
		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
			systemctl reboot
		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
			exit
        else
			show_msg
        fi
        ;;
    $lock)
		 $lockcmd
        ;;
    $suspend)
		ans=$(get_confirmation &)
		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
			playerctl -a pause
			$lockcmd
			systemctl suspend
		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
			exit
        else
			show_msg
        fi
        ;;
    $logout)
		ans=$(get_confirmation &)
		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
			swaymsg exit
		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
			exit
        else
			show_msg
        fi
        ;;
esac
