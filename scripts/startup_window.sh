#!/bin/bash

# Shittiest shitty script.

# 3 types of startup window designs
#	- boxSlash
#	- box
#	- slash
#	You can add another by making another option in the case statement. (eg. custom)
startupwindow="boxSlash"

main () {
	case $startupwindow in 
		"boxSlash") boxSlash ;;
		"box") box ;;
		"slash") slash ;;
		# Insert your function here
	esac
}

boxSlash () {
	alacritty -t welcome -e bash -c '
        neofetch --ascii ${HOME}/.config/neofetch/archlinux.txt;

        printf "                     \033[36;1m[-----------------------------------------------------------------]\033[0m";
        printf "\n                     \033[36;1m|\033[0m    \033[34;1m/ / / / / / / /\033[0m  Welcome to Arch Linux! \033[34;1m\ \ \ \ \ \ \ \ \ \033[0m   \033[36;1m|\033[0m\n                     \033[36;1m|\033[0m   \033[34;1m/ / / / / / /\033[0m Custom XMonad config by Anapal  \033[34;1m\ \ \ \ \ \ \ \033[0m  \033[36;1m|\033[0m \n";
        printf "                     \033[36;1m[-----------------------------------------------------------------]\033[0m";
        printf "\n\n\e[1;36m%-6s\e[m" "                               Super ";
        printf "+";
        printf "\e[1;36m%-6s\e[m" " Shift ";
        printf "+"
printf "\e[1;36m%-6s\e[m" " Enter ";
        printf "to open a new terminal.\n                             ";
        printf "\e[1;36m%-6s\e[m" "Super";
        printf "+";
        printf "\e[1;36m%-6s\e[m" " Shift ";
        printf "+";
        printf "\e[1;36m%-6s\e[m" " Slash ";
        printf "to show a list of programs.";
        printf "\n\e[1;36m%-6s\e[m" "                       Super ";
        printf "+";
        printf "\e[1;36m%-6s\e[m" " Control ";
        printf "+";
        printf "\e[1;36m%-6s\e[m" " Slash ";
        printf "to show a list of xmonad keybindings.\n\n\n                                     Press ";
        printf "\e[1;33m%-6s\e[m" "enter ";
        printf "to close this window.";
        printf "\033[?25l";
       
        read -p ""'
}

box () {
	alacritty -t welcome -e bash -c '
        neofetch --ascii ${HOME}/.config/neofetch/archlinux.txt

        printf "                     \033[36;1m[-----------------------------------------------------------------]\033[0m"
        printf "\n                     \033[36;1m|\033[0m                     Welcome to Arch Linux!                      \033[36;1m|\033[0m\n                     \033[36;1m|\033[0m                 Custom XMonad config by Anapal                  \033[36;1m|\033[0m \n"
        printf "                     \033[36;1m[-----------------------------------------------------------------]\033[0m"
        printf "\e[1;36m%-6s\e[m" "                               Super "
        printf "+"
        printf "\e[1;36m%-6s\e[m" " Shift "
        printf "+"
        printf "\e[1;36m%-6s\e[m" " Enter "
        printf "to open a new terminal.\n                             "
        printf "\e[1;36m%-6s\e[m" "Super"
        printf "+"
        printf "\e[1;36m%-6s\e[m" " Shift "
        printf "+"
        printf "\e[1;36m%-6s\e[m" " Slash "
        printf "to show a list of programs."
        printf "\n\e[1;36m%-6s\e[m" "                       Super "
        printf "+"
        printf "\e[1;36m%-6s\e[m" " Control "
        printf "+"
        printf "\e[1;36m%-6s\e[m" " Slash "
        printf "to show a list of xmonad keybindings.\n\n\n                                     Press "
        printf "\e[1;33m%-6s\e[m" "enter "
        printf "to close this window."
        printf "\033[?25l"

        read -p ""'
}

slash () {
	alacritty -t welcome -e bash -c '
        neofetch --ascii ${HOME}/.config/neofetch/archlinux.txt

        printf "\n                        \033[34;1m/ / / / / / / / /\033[0m  Welcome to Arch Linux!  \033[34;1m\ \ \ \ \ \ \ \ \\033[0m    \n                       \033[34;1m/ / / / / / / /\033[0m Custom XMonad config by Anapal \033[34;1m\ \ \ \ \ \ \ \\033[0m   \n\n"
        printf "\e[1;36m%-6s\e[m" "                               Super "
        printf "+"
        printf "\e[1;36m%-6s\e[m" " Shift "
        printf "+"
        printf "\e[1;36m%-6s\e[m" " Enter "
        printf "to open a new terminal.\n                             "
        printf "\e[1;36m%-6s\e[m" "Super"
        printf "+"
        printf "\e[1;36m%-6s\e[m" " Shift "
        printf "+"
        printf "\e[1;36m%-6s\e[m" " Slash "
        printf "to show a list of programs."
        printf "\n\e[1;36m%-6s\e[m" "                       Super "
        printf "+"
        printf "\e[1;36m%-6s\e[m" " Control "
        printf "+"
        printf "\e[1;36m%-6s\e[m" " Slash "
        printf "to show a list of xmonad keybindings.\n\n\n                                     Press "
        printf "\e[1;33m%-6s\e[m" "enter "
        printf "to close this window."
        printf "\033[?25l"
        
        read -p ""'
}

# Add your function here

main "$@"
