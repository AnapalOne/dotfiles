#!/bin/sh

if xinput list-props 14 | grep "Device Enabled (165):.*1" >/dev/null; then
    xinput disable 14
    notify-send -a "touchpad toggle" "Touchpad disabled." -h string:x-canonical-private-synchronous:my-notification
else
    xinput enable 14
    notify-send -a "touchpad toggle" "Touchpad enabled." -h string:x-canonical-private-synchronous:my-notification
fi