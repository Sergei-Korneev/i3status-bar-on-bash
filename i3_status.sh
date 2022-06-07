#!/bin/bash


interval=2

while true; do (
	cputemp=$(sensors| sed -n 19p| awk '{print "cput: " $4}')
	timedate=$(date +'%a %d %b %Y %H:%M')
        svolume=$(pactl  get-sink-volume 45  | sed -n 1p|  awk '{print "vol: R" $5 " L" $12}')
	mem=$(free | sed -n 2p | awk '{printf "%s%.0f%s%.0f\n" ,  "mem: ",$3/1024,"/",$7/1024}')
	cpu=""$[100-$(vmstat 1 2|tail -1|awk '{print $15}')]"%"
	battery=$(upower -i $(upower -e | grep BAT) | grep  -E "state|to\ full|to\ empty|percentage" |  tr -d '\n' | sed 's/  */ /g')
        clear
	echo "cpu: $cpu | $battery | $mem | $cputemp | $svolume | $timedate"
	sleep $interval)
done
