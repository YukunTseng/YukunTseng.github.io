#!/bin/bash

printf "time,BusyWorkers,IdleWorkers,Processes\n"
while true
do
  printf "%s," "$(date '+%Y-%m-%d %H:%M:%S')"
  curl -s localhost/server-status?auto\
       | awk '/BusyWorkers/ { b=$2 }
              /IdleWorkers/ { i=$2 }
              /Processes/   { p=$2 }
              END {
              printf "%s,%s,%s\n",b,i,p
              }'
   sleep 1
done