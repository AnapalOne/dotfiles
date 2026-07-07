#!/bin/bash

gpuUsageGFX=$(amdgpu_top -J | head -n 1 | jq -c -r '.devices[] | .gpu_activity | to_entries[0].value.value')
gpuUsageMem=$(amdgpu_top -J | head -n 1 | jq -c -r '.devices[] | .gpu_activity | to_entries[2].value.value')

if [[ $gpuUsageGFX -gt 85 ]]; then
    gpuColorGFX="#8b0000"
elif [[ $gpuUsageGFX -gt 50 ]]; then
    gpuColorGFX="#ff8c00"
else
    gpuColorGFX="#1bc800"
fi

if [[ $gpuUsageMem -gt 85 ]]; then
    gpuColorMem="#8b0000"
elif [[ $gpuUsageMem -gt 50 ]]; then
    gpuColorMem="#ff8c00"
else
    gpuColorMem="#1bc800"
fi

printf "%s" "<fn=1><fc=#f0f>󰾲</fc></fn> <fc=$gpuColorGFX>$gpuUsageGFX</fc>% / <fn=1><fc=#f0f>󰍛</fc></fn> <fc=$gpuColorMem>$gpuUsageMem</fc>%"
