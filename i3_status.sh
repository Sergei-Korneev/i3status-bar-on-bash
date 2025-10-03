#!/bin/bash


interval=4

while true; do (
         topcpu="$( ps -aeo %cpu,command --sort=-%cpu  |   sed -n 2p |  awk '{print $1 "% " $2 }')"
         timedate="$(date +'%a %d %b %Y %H:%M')"
         svolume="$(pactl  get-sink-volume $(pactl list short sinks |  awk '{print $1}' )  | sed -n 1p|  awk '{print "R" $5 " L" $12}')"
         mem="$(free | sed -n 2p | awk '{printf "%s%.0f%s%.0f Gb\n" ,  "",$3/1024/1024,"/",$7/1024/1024}')"
         swp="$(free | sed -n 3p | awk '{printf "%s%.0f%s%.0f Gb\n" ,  "",$2/1024/1024,"/",$3/1024/1024}')"
         cputemp="$(sensors 2> /dev/null | grep 'Package id 0:'  | awk '{print $4}')"
         cpu="$(top -bn2 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,'|awk '{print 100-$8 "%"}')"
         battery="$(upower -i $(upower -e | grep BAT) | grep  -E "state|to\ full|to\ empty|percentage" | sed -e  ':a;N;$!ba;s/\n/,/g;s/  */ /g' )"
         ineta="$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'|  sed -e  ':a;N;$!ba;s/\n/, /g;s/  */ /g')"
         disks="$(df -H | grep /media | while read -r F; do echo  "$F"  | awk {'print " | " $6  ": "  $2 "/" $4'} | tr -d '\n'| sed -e "s/\/media\///;s/\/run//;s/$USER\///" ; done)"
        clear
      	# https://www.compart.com/en/unicode
        echo -en     "\xF0\x9F\x96\xB4$disks | \xF0\x9D\x84\x9C $cpu"/"$cputemp | \xE2\x8F\xB1 $topcpu | \xF0\x9F\x99\xBE M: $mem S: $swp | \xF0\x9F\x94\x8B $battery | \xF0\x9F\x96\xA7 $ineta | \xF0\x9F\x8E\xA7 $svolume | $timedate"
 sleep $interval)
done
