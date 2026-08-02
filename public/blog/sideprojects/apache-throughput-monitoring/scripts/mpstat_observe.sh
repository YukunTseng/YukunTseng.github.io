#!/bin/bash

printf "time,CPU,%%usr,%%nice,%%sys,%%iowait,%%irq,%%soft,%%steal,%%guest,%%gnice,%%idle\n"
while true
do
mpstat 1 1 | head -4 | tail -1 | tr -s ' ' ',' | sed 's/^,//'
done