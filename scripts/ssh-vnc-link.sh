#!/bin/sh
echo 'vnc ports default from 5900 onwards'
ssh 192.168.178.115 -p 8096 -L $1:127.0.0.1:$1 -N -f -l u0_a204
