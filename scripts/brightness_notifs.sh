#!/bin/bash

brightness=$(brillo | sed 's/\.[0-9][0-9]//g') 
notify-send --app-name="system monitor" -u low -h int:value:$brightness "Brightness"
