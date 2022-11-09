#!/bin/sh

if pgrep screenkey > /dev/null; then
	pkill screenkey
	notify-send -a screenkey "Display key inputs disabled." -h string:x-canonical-private-synchronous:my-notification
else
	screenkey &
	notify-send -a screenkey "Display key inputs enabled." -h string:x-canonical-private-synchronous:my-notification
fi