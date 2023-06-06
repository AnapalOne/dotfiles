#!/bin/sh

column_separator="$(printf "\033[34;1m%.s─\033[0m" $(seq 1 100))"

cat ~/.xmonad/xmonad.hs | 
	sed '/^    [-][-] [/][/] windows$/,$!d' |  # filter everything before [Key Binds] 
	awk '/^[-].+/{exit} {print}' | 			   # filter everything after [Key Binds]
	head -n -3 |  							   # delete last 3 lines
	sed -e 's/^    //g' -e 's/^. [(][(]/   /g' -e '/^] ++/d' -e 's/[\)].*--/ = /g' -e 's/[)].*[)]//g' -e 's/-- /   /g' | # filter out parenthesis, brackets, commas, and dashes from keybinds
	sed -e '/modm [.][|][.] m[,] k/,$d' | 																			     # filter out keybindings code cuz it doesn't show properly and i'm too lazy to fix it
	awk -v col_sep="$column_separator" '/[/][/]/{ print col_sep"\n\033[36;1m"$0"\033[0m\n"col_sep; next } { print }' | sed 's/[/][/]//g' | # filter out "//" from descriptions, make nice orange bars
	sed -e "s/.|./"$'\e[31;1m'"&"$'\e[m'"/g" -e "s/,/"$'\e[31;1m'"&"$'\e[m'"/g" -e "s/-/"$'\e[31;1m'"&"$'\e[m'"/g"       # add color to [.|.], [-], and [,]

msg="Press enter to exit."
printf "\n\n%*s\n" $(((${#msg}+$COLUMNS)/2)) "$msg" | sed -e "s/enter/"$'\e[33;1m'"&"$'\e[m'"/g"
printf '\033[?25l'
read -sp ""