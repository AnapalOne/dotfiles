#!/bin/bash

volume="$(pamixer --get-volume | sed -e "s/%//g")"
muted="$(pacmd list-sinks | awk '/muted/ {a=$2} END{print a}')"

if [[ $volume -le 20 ]]; then
    volume_logo=""
elif [[ $volume -le 60 ]]; then
    volume_logo=""
else
    volume_logo=""
fi

if [[ "$muted" == "yes" ]]; then
    volume_logo="󰝟"
fi

notify-send --app-name="system monitor" -u low -h int:value:$volume -h string:x-canonical-private-synchronous:volume_notifs "Volume  $volume_logo"
