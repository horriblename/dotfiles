#!/bin/sh
files=./*.pdf

for f in $files; do
   res=$(pdftotext "$f" - 2>/dev/null | grep --color=always -i "$1")
   [ -z "$res" ] || printf '\x1b[33;1m  %s:\x1b[0m\n' "$f" && echo "$res"
done
