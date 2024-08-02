#!/bin/bash

#Since eww currently does not go in front of any windows for some reason, this is a temporary fix.

lastsong=
while true; do
    currentsong=\"$(playerctl metadata --player=spotify,cmus,spotifyd --format "{{ artist }} - {{ title }}" 2> /dev/null)\"

    if [[ "$currentsong" != "$lastsong" ]] && [[ -n "$currentsong" ]] && [[ "$currentsong" != "\"\"" ]]; then
    	eww reload
    fi

    lastsong=$currentsong

    sleep 10
done