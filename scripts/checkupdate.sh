#!/bin/bash

# Check for updates and print output in use inside xmobar config.
# Include as command in xmobar config file with:
#    => Run Com "/home/anapal/.config/xmonad/scripts/checkupdate.sh" [] "checkupdates" 3000

updates=$(checkupdates | wc -l)
if [[ $updates -gt 0 ]]; then
    printf "%s" "<fn=1><fc=#1793d1>󰣇</fc></fn> $updates updates"
else
    printf ""
fi