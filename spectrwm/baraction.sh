#!/bin/bash

# ICONS

BATTERY_ICONS=(           )
BOLT_ICON=
PLUG_ICON=
TIME_ICON=
CAL_ICON=
VOL_ICONS=(      )
MUSIC_ICON=
WIFI_ICON=
EXCLAMATION_ICON=

# MODULES

wifi() {
    SSID=$(iw dev wlp2s0 link | grep SSID | cut -d ' ' -f 2)

    if [ -n "$SSID" ]; then
        echo "$WIFI_ICON $SSID"
    else
        echo "$EXCLAMATION_ICON Not Connected"
    fi
}

sound(){
	VOL_INT=$(pamixer --get-volume | cut -d ' ' -f 1)
	VOL_MUTE=$(pamixer --get-mute)
    NOW_PLAYING=$(ncmpcpp --current-song='%a - %t')

	if [ $VOL_MUTE = true ]; then
        VOL_ICON=${VOL_ICONS[0]}
        VOL_STR='[Muted]'
    else
        if [ $VOL_INT -le 30 ]; then
            VOL_ICON=${VOL_ICONS[1]}
        elif [ $VOL_INT -le 60 ]; then
            VOL_ICON=${VOL_ICONS[2]}
        elif [ $VOL_INT -gt 60 ]; then
            VOL_ICON=${VOL_ICONS[3]}
        fi
	    VOL_STR=$VOL_INT%
    fi

    if [ -n "$NOW_PLAYING" ]; then
        echo "$MUSIC_ICON ${NOW_PLAYING:0:40}  $VOL_ICON $VOL_STR "
    else
        echo "$VOL_ICON $VOL_STR "
    fi
}

bat() {
	BAT_PER=$(cat /sys/class/power_supply/BAT0/capacity)
    BAT_STATE=$(cat /sys/class/power_supply/BAT0/status)

    i=$((BAT_PER/20))
    if [ $BAT_STATE = 'Full' ]; then
        BAT_ICON=$BOLT_ICON
    elif [ $BAT_STATE = 'Charging' ]; then
        BAT_ICON=$PLUG_ICON
    else
        if [ $BAT_PER -eq 100 ]; then
            BAT_ICON=${BATTERY_ICONS[4]}
        else
            BAT_ICON=${BATTERY_ICONS[$i]}
        fi
    fi

	echo "$BAT_ICON $BAT_PER% "
}

dte() {
  dte=$(date +"%a %B %d")
  echo "$CAL_ICON $dte "
}

tie() {
  tme=$(date +"%I:%M%P")
  echo "$TIME_ICON $tme "
}

# OUTPUT

while true; do
    echo "+@bg=0; +@bg=1;+2<$(wifi) +<+@bg=0;+3<+@bg=2;+2<$(sound) +@bg=0;+3<+@bg=3;+2<$(bat) +@bg=0;+3<+@bg=4;+2<$(dte) +@bg=0;+3<+@bg=5;+2<$(tie) "
	sleep 1
done

