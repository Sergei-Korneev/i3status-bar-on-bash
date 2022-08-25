 #!/bin/bash
  2 
  3 
  4 interval=3
  5 
  6 while true; do (
  7          
  8          topcpu="TopCpu: $(ps -eo cmd,%cpu --sort=-%cpu |  sed -n 2p)"
  9          timedate="$(date +'%a %d %b %Y %H:%M')"
 10          svolume="$(pactl  get-sink-volume $(pactl list short sinks |  awk '{print $1}' )  | sed -n 1p|  awk '{print "vol: R" $5 " L" $12}')"
 11          mem="$(free | sed -n 2p | awk '{printf "%s%.0f%s%.0f\n" ,  "mem: ",$3/1024,"/",$7/1024}')"
 12          cputemp="Temp: $(sensors 2> /dev/null | grep 'Package id 0:'  | awk '{print $4}')"
 13          cpu="CPU: $(top -bn2 | grep '%Cpu' | tail -1 | grep -P '(....|...) id,'|awk '{print 100-$8 "%"}')"
 14          battery="Battery: $(upower -i $(upower -e | grep BAT) | grep  -E "state|to\ full|to\ empty|percentage" |  tr -d '\n' | sed 's/  */ /g')"
 15          ineta=$(ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'|  tr  '\n' ' ')
 16         clear
 17         echo "$cpu | $topcpu | $cputemp | $battery | $mem | $ineta | $svolume | $timedate"
 18  sleep $interval)
 19 done
