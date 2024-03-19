#!/bin/bash

i=$1
brightness="$(brillo | sed 's/\.[0-9][0-9]//g')"
notify-send --app-name="system monitor" -h int:value:$brightness "Brightness"
