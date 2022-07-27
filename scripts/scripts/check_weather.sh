#!/bin/sh
note="$HOME/.local/share/plasma_notes/weathers-6699-4493-show-displayb4b"
location='Duisburg'
# query="wttr.in/$location?format=3"
query="wttr.in/$location?format=%c%t"

weather=$(curl "$query" 2>/dev/null || echo "curl error")
[ "$weather" = "curl error" ] && exit
date=$(date +%d/%m)
html="<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">
<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">
p, li { white-space: pre-wrap; }
</style></head><body style=\" font-family:'Google Sans'; font-size:16pt; font-weight:400; font-style:normal;\">
<p style=\" padding-top:2px;margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\">$location <span style=\"color:red;margin-left:auto;\">$date</span></p>
<p style=\" padding-bottom:2px;margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;font-size:40pt;text-align:center;\">$weather</p>
</body></html>
"

echo "$weather"
echo "$html" > "$note"
