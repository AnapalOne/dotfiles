#!/bin/bash

help="$(cat $HOME/.config/xmonad/help)"

printf "$help"
printf '\033[?25l'
read -sp "" prompt

if [[ $prompt == 'e' ]]; then
	vim $HOME/.config/xmonad/help
fi

exit
