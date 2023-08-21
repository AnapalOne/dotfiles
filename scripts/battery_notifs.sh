#!/bin/bash

# When battery reaches 10% or 5%, notify the user.
# Special thanks to KamilCuk on StackOverflow for helping with issues

display_low() {
   notify-send --urgency=critical "Low Battery! (15%)" "Charge your laptop now."
    espeak "Low battery. Please charge."
}
display_crit() {
    notify-send --urgency=critical "Critical Battery! (10%)" "Charge your laptop ASAP. Before you lose your data. Seriously."
    espeak "Critical battery. Please charge."
}
display_really_crit() {
    notify-send --urgency=critical "REALLY Critical Battery! (5%)" "Dude, your battery is going to go to the landfill soon."
    espeak "Critical battery. Charge immediately."
}

battery_to_state() {
   battery=$1
   # lets use bash syntax
   if (( battery <= 5 )); then
       echo really_crit
   elif (( battery <= 10 )); then
       echo crit
   elif (( battery <= 15 )); then
       echo low
   fi
   # if greater than 15, state is empty
}

laststate=

while true; do
    batteryStatus=$(cat /sys/class/power_supply/BAT0/status)
    battery=$(cat /sys/class/power_supply/BAT0/capacity)
    curstate=$(battery_to_state "$battery")
    if
       # Only display when not charging
       [[ "$batteryStatus" != "Charging" ]] &&
       # Only display if the state is not empty (below 15!)
       [[ -n "$curstate" ]] &&
       # Only display if the state __changed__!
       [[ "$laststate" != "$curstate" ]]
    then
       # jump to one of display_* functions, depending on state 
       "display_$curstate"
    fi
    laststate=$curstate
    #
    sleep 5
done
