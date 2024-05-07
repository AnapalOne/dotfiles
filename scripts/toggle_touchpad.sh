#!/bin/bash

touchpad_id=$(xinput | grep "Touchpad" | sed -e 's/^.*=//' | sed -e 's/[ \t].*//')
touchpad_enabled=$(xinput list-props $touchpad_id | grep "Device Enabled" | sed -e 's/^.*:\t//')

case $1 in
    "-enable")
        xinput enable $touchpad_id
        notify-send -a "touchpad toggle" "Touchpad enabled." -h string:x-canonical-private-synchronous:my-notification
        ;;
    "-disable")
        xinput disable $touchpad_id
        notify-send -a "touchpad toggle" "Touchpad disabled." -h string:x-canonical-private-synchronous:my-notification
        ;;
esac



#if [[ $touchpad_enabled -eq 0 ]] || [[ $1 == "-enable" ]]; then
#    xinput enable $touchpad_id
#    notify-send -a "touchpad toggle" "Touchpad enabled." -h string:x-canonical-private-synchronous:my-notification
#fi

#if [[ $touchpad_enabled -eq 1 ]] || [[ $1 == "-disable" ]]; then
#    xinput disable $touchpad_id
#    notify-send -a "touchpad toggle" "Touchpad disabled." -h string:x-canonical-private-synchronous:my-notification
#fi
