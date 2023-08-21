#!/bin/bash

if pgrep screenkey > /dev/null; then
	pkill screenkey
	notify-send -a screenkey "Display key inputs disabled." -h string:x-canonical-private-synchronous:screenkey
else
	screenkey --no-systray &
	notify-send -a screenkey "Display key inputs enabled." -h string:x-canonical-private-synchronous:screenkey
fi