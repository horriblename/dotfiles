#!/bin/sh

save_file="/mnt/BUP/Documents_/scr_rec_$(date +'%Y-%m-%d_%H%M').mkv"
[ -f "$save_file" ] && save_file="/mnt/BUP/Documents_/scr_rec_$(date +'%Y-%m-%d_%H%M-%S').mkv"

"Recording to $save_file"

ffmpeg -f x11grab -i "$DISPLAY" "$save_file"
