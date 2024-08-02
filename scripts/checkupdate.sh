#!/bin/bash

updates=$(checkupdates | wc -l)
if [[ $updates -gt 0 ]]; then
    printf "%s" "<fn=1><fc=#1793d1>󰣇</fc></fn> $updates updates"
else
    printf ""
fi