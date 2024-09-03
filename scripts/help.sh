#!/bin/bash

print_help () {
    help="$(cat $HOME/.config/xmonad/help | 
            sed -e 's/\$clear\$/\\033\[0m/g' \
                -e 's/\$cyan\$/\\033\[36;1m/g' \
                -e 's/\$orange\$/\\033\[34;1m/g' \
                -e 's/\$red\$/\\033\[31;1m/g' \
                -e 's/\$white\$/\\033\[37;1m/g' \
                -e 's/\$yellow\$/\\033\[33;1m/g' \
                -e 's/\$blue\$/\\033\[35;1m/g' )"
    printf "$help"
    printf '\033[?25l'
    read -sp "" prompt

    if [[ $prompt == 'e' ]]; then
        vim $HOME/.config/xmonad/help
        print_help
    fi
}

print_help
exit
