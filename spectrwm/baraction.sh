#!/bin/bash

# battery icons
BATTERY_CHARGING=(           )
TIME_ICON=
CAL_ICON=
VOL_ICONS=(    )
MUSIC_ICON=

song() {
    song=$(ncmpcpp --current-song='%a - %t')
    if [ -n "$song" ]
    then
        echo -e "$MUSIC_ICON $song "
    fi
}

vol(){
	VOL_INT=$(pulsemixer --get-volume | cut -d ' ' -f 1)
	VOL_MUTE=$(pulsemixer --get-mute)
	if [ $VOL_MUTE -eq 1 ]; then
        VOL_ICON=${VOL_ICONS[0]}
        VOL_STR=''
    else
        if [ $VOL_INT -lt 60 ]; then
            VOL_ICON=${VOL_ICONS[1]}
        elif [ $VOL_INT -ge 60 ]; then
            VOL_ICON=${VOL_ICONS[2]}
        fi
	    VOL_STR=$VOL_INT%
    fi

    echo -e "$VOL_ICON $VOL_STR "
}

bat() {
	BAT_PER=$(cat /sys/class/power_supply/BAT0/capacity)
    BAT_STATE=$(cat /sys/class/power_supply/BAT0/status)

    i=$((BAT_PER/20))
    if [ $BAT_STATE = 'Full' ]; then
        BAT_ICON=${BATTERY_CHARGING[4]}
    else
        BAT_ICON=${BATTERY_CHARGING[$i]}
    fi

	echo -e "$BAT_ICON $BAT_PER% "
}

dte() {
  dte=$(date +"%a %B %d")
  echo -e "$CAL_ICON $dte "
}

tie() {
  tme=$(date +"%I:%M%P")
  echo -e "$TIME_ICON $tme "
}

while :; do
    echo "   +@bg=2;  $(song) $(vol) +@bg=0;   +@bg=3;  $(bat) +@bg=0;   +@bg=4;  $(tie) +@bg=0;   +@bg=5;  $(dte) "
	sleep 1
done

