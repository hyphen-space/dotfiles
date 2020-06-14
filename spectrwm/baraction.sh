#!/bin/bash

song() {
    song=$(ncmpcpp --current-song)
    if [ -n "$song" ]
    then
        echo -e "+@fg=1;now playing+@fg=0; $song "
    fi
}

vol(){
    vol=$(amixer -D pulse get Master | awk -F 'Left:|[][]' 'BEGIN {RS=""}{ print $3 }')
	echo -e "+@fg=1;vol+@fg=0; $vol "
}

bat() {
	power=$(cat /sys/class/power_supply/BAT0/capacity)
	echo -e "+@fg=1;bat+@fg=0; $power% "
}

dte() {
  dte=$(date +"%a %B %d")
  echo -e "+@fg=1;date+@fg=0; $dte "
}

tie() {
  tme=$(date +"%I:%M%P")
  echo -e "+@fg=1;time+@fg=0; $tme "
}

while :; do
    echo "$(song) $(vol) $(bat) $(tie) $(dte)"
	sleep 2
done

