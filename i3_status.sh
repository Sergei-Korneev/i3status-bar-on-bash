#!/bin/bash


interval=3

while true; do (
         
         timedate=$(date +'%a %d %b %Y %H:%M')
         svolume=$(pactl  get-sink-volume $(pactl list short sinks |  awk '{print $1}' )  | sed -n 1p|  awk '{print "vol: R" $5 " L" $12}')
         mem=$(free | sed -n 2p | awk '{printf "%s%.0f%s%.0f\n" ,  "mem: ",$3/1024,"/",$7/1024}')
         cputemp="Temp: $(sensors 2> /dev/null | grep 'Package id 0:'  | awk '{print $4}')"
         cpu="CPU: $(top -bn2 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,'|awk '{print 100-$8 "%"}')"
         battery="Battery: $(upower -i $(upower -e | grep BAT) | grep  -E "state|to\ full|to\ empty|percentage" |  tr -d '\n' | sed 's/  */ /g')"
         ineta=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'|  tr  '\n' ' ')
        clear
        echo "$cpu | $cputemp | $battery | $mem | $ineta | $svolume | $timedate"
 sleep $interval)
done

