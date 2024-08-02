#!/bin/bash

volume="$(pamixer --get-volume-human | sed -e "s/%//g")"

if [[ $volume == "muted" ]]; then
    notify-send -p --app-name="system monitor" -u low "Volume" "Muted." -h string:x-canonical-private-synchronous:volume_notifs --icon="null"
    exit
fi

notify-send --app-name="system monitor" -u low -h int:value:$volume -h string:x-canonical-private-synchronous:volume_notifs "Volume" --icon="null"
