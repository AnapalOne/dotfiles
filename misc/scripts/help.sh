#!/bin/sh

help="$(cat $HOME/.config/xmonad/help)"

printf "$help"
read -p "" -s prompt

if [[ $prompt == 'e' ]]; then
	vim $HOME/.config/xmonad/help
fi

exit
