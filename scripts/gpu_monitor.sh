#!/bin/bash

# GPU monitor for use with xmobar with devices using nvidia gpu. 
# Include as command in xmobar config file with:
#    => Run Com "{PATH-OF-DIRECTORY}/gpu_monitor" [] "gpu" 50

# TODO: check installed gpu and change gpuUsage for each detected gpu.
#   use nvidia-smi for nvidia
#   use intel-gpu-tools for intel
#   use fglrx (closed drivers) or radeontop for amd

gpuUsage=$(nvidia-smi -a | grep Gpu | sed 's/[ ]*Gpu[ ]*: //' | sed 's/ %//')
if [[ gpuUsage -gt 85 ]]; then
    printf "%s" "<fn=1><fc=#f0f>󰾲</fc></fn> <fc=#8b0000>$gpuUsage</fc>%"
elif [[ gpuUsage -gt 50 ]]; then
    printf "%s" "<fn=1><fc=#f0f>󰾲</fc></fn> <fc=#ff8c00>$gpuUsage</fc>%"
else
    printf "%s" "<fn=1><fc=#f0f>󰾲</fc></fn> <fc=#1bc800>$gpuUsage</fc>%"
fi
