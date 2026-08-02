#!/bin/bash

printf "time,r,b,swpd,free,buff,cache,si,so,bi,bo,in,cs,us,sy,id,wa,st,gu\n"
while true
do
 printf "%s," "$(date '+%Y-%m-%d %H:%M:%S')" ; vmstat 1 2 | tail -1 | tr -s ' ' ',' | sed 's/^,//'
done