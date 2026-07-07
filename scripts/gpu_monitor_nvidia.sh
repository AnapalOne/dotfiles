#!/bin/bash

gpuUsage=$(nvidia-smi -a | grep Gpu | sed 's/[ ]*Gpu[ ]*: //' | sed 's/ %//')
if [[ gpuUsage -gt 85 ]]; then
    printf "%s" "<fn=1><fc=#f0f>󰾲</fc></fn> <fc=#8b0000>$gpuUsage</fc>%"
elif [[ gpuUsage -gt 50 ]]; then
    printf "%s" "<fn=1><fc=#f0f>󰾲</fc></fn> <fc=#ff8c00>$gpuUsage</fc>%"
else
    printf "%s" "<fn=1><fc=#f0f>󰾲</fc></fn> <fc=#1bc800>$gpuUsage</fc>%"
fi
