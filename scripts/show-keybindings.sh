#!/bin/bash

# Extracts and displays only the keybindings in my xmonad conifg. (~/.xmonad/xmonad.hs)

# P.S.
# Will only work on this specific config, as sed and awk specifically filters my xmonad format.
# Will break if even one character is added, thus this script is very fragile.

column_separator="$(printf "\033[34;1m%.s─\033[0m" $(seq 1 100))"

cat ~/.xmonad/xmonad.hs | 
	sed '/^\s*[-][-] [/][/] windows$/,$!d' |  # filter everything before [Key Binds] 
	awk '/^[-].+/{exit} {print}' | 			  # filter everything after [Key Binds]
	head -n -4 |  							  # delete last 3 lines

	# filter out parenthesis, brackets, commas, and dashes from keybinds
	sed -e 's/^\s*//g' \
		-e 's/^. [(][(]/   /g' \
		-e '/^] ++/d' \
		-e 's/[\)].*--/ = /g' \
		-e 's/[)].*[)]//g' \
		-e 's/-- /   /g' |

	# filter out keybindings code (cuz it doesn't show properly) until myMouseBindings
	sed -e '/^\s*modm [.][|][.] m[,] k/,/^myMouseBinds/d' |

	# filter out "//" from descriptions, make nice orange bars
	awk -v col_sep="$column_separator" '/[/][/]/{ print col_sep"\n\033[36;1m"$0"\033[0m\n"col_sep; next } { print }' |
	sed 's/[/][/]//g' |

	# add color to [.|.], [-], and [,]
	sed -e "s/.|./"$'\e[31;1m'"&"$'\e[m'"/g" \
	    -e "s/,/"$'\e[31;1m'"&"$'\e[m'"/g" \
	    -e "s/-/"$'\e[31;1m'"&"$'\e[m'"/g"

msg="Press enter to exit."
printf "\n\n%*s\n" $(((${#msg}+$COLUMNS)/2)) "$msg" | sed -e "s/enter/"$'\e[33;1m'"&"$'\e[m'"/g"
printf '\033[?25l'
read -sp ""