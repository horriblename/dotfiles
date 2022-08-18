#/bin/sh
tp_device=`xinput | awk '/SynPS\/2/ {sub("id=", "", $6); print $6}'`
xinput disable $tp_device
xinput set-button-map $tp_device 1 3 0 4 5 6 7
xinput enable $tp_device
