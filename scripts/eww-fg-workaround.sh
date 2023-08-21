#!/bin/bash

# Since eww does not want to go in front of any windows, this (bad) hack puts eww at the top of 
#   the window stack by restarting eww. This is bad because eww obstructs focus with other 
#   windows when in fg and could potentially cause problems with eww itself.

# TODO: find a way to put eww in bg when not in use, then put in fg when called, and vice versa without restarting eww.

lastsong=
while true; do
    currentsong=\"$(playerctl metadata --player=spotify,cmus,spotifyd --format "{{ artist }} - {{ title }}" 2> /dev/null)\"

    if [[ "$currentsong" != "$lastsong" ]] && [[ -n "$currentsong" ]] && [[ "$currentsong" != "\"\"" ]]; then
    	eww reload
    fi

    lastsong=$currentsong

    sleep 10
done