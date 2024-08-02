#!/bin/bash

file=$1
anim='nice -n 19 xwinwrap -g 1920x1080 -ni -fdt -fs -un -s -st -nf -ovr -- mpv -wid WID --really-quiet --no-audio --loop-file --framedrop=vo  --hwdec=vdpau --vo=vdpau --panscan="1.0"'
cache=~/.anim_wallpaper

if [[ $file ]]; then
    install -m 755 <(echo "$anim $file") $cache
    eval $cache &
    exit
fi

if [[ -e $cache ]]; then
    eval $cache &
else
    echo "cache does not exist, please input a wallpaper" >&2
fi
