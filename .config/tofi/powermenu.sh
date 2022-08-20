#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3
## source: https://github.com/archcraft-os/archcraft-dwm/blob/main/archcraft-dwm/shared/wofi/bin/powermenu

#DIR="/usr/share/archcraft/dwm"
DIR=${XDG_CONFIG_HOME:-$HOME/.config}/tofi
echo $DIR

font='/usr/share/fonts/TTF/Fira Code Regular Nerd Font Complete.ttf'
tofi_styled="tofi -c $DIR/gruvbox-menu.ini"
lockcmd='swaylock -f'

# Options
shutdown=''
reboot='勒'
lock=''
suspend='⏾'
logout=''

# Get user confirmation 
get_confirmation() {
	res=$(printf '\n  ' | $tofi_styled --prompt-text "$1 │ " --horizontal true \
		--font "$font" --font-size 20 --height 70 --width 230 --result-spacing=30)
	[ res = '' ] && echo yes || echo no
}

# Show message
show_msg() {
	tofi --prompt-text "Options  -  yes / y / no / n"
}

# Variable passed to wofi
options="$shutdown\n$reboot\n$lock\n$suspend\n$logout"

chosen="$(echo -e "$options" | $tofi_styled --prompt-text '' --horizontal true \
	--font "$font" --font-size 20 --height 70 --width '300' --result-spacing=30)"
case $chosen in
    $shutdown)
		ans=$(get_confirmation $shutdown &)
		if [[ $ans == "yes" ]] || [[ $ans == "YES" ]] || [[ $ans == "y" ]]; then
			systemctl poweroff
		elif [[ $ans == "no" ]] || [[ $ans == "NO" ]] || [[ $ans == "n" ]]; then
			exit
        else
			show_msg
        fi
        ;;
    $reboot)
		ans=$(get_confirmation $reboot &)
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
		ans=$(get_confirmation $suspend &)
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
