# ---------------------------------------------------------
# --               zsh config by Anapal                  --
# --     My personal config for my (or your) needs.      --
# --                                                     --
# --      > https://github.com/AnapalOne/dotfiles        --
# ---------------------------------------------------------

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

autoload -Uz add-zsh-hook

# ------------------ Exports -------------------------

export PATH=$PATH:/usr/local/bin
export VISUAL="code"
export EDITOR="vim"


# ------------------ Aliases -------------------------

alias reboot='sudo systemctl reboot'
alias shutdown='sudo systemctl poweroff'
alias hibernate='sudo systemctl hibernate'

alias ls='source ranger'
alias grep='grep --color'


# ------------------ Options -------------------------
# > See [https://zsh.sourceforge.io/Intro/intro_16.html] for more.

setopt globdots			   # Show hidden files.
setopt histignorespace	   # Don't repeat same lines from history.
setopt interactivecomments # Enable comments by using #.

ZSH_THEME="powerlevel10k/powerlevel10k"
#ZSH_HIGHLIGHT_STYLES[comment]="fg=black,bold"


# ------------------ History -------------------------

HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000


# ---------------- Auto-complete ----------------------

zstyle ':completion:*' menu select matcher-list 'm:{a-z}={A-Za-z}' 
# autoload -Uz compinit
# compinit


# ------------------ Keybinds -------------------------

bindkey -e

bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey '^[[A' 	  history-substring-search-up
bindkey '^[[B' 	  history-substring-search-down


# ------------------ Sources -------------------------

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.zsh/zsh-autocomplete/zsh-autocomplete.plugin.zsh

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme


# ------------------------------------------------
# //-- Terminal prompt configuration.
#  /-- See [https://man.archlinux.org/man/zshmisc.1#SIMPLE_PROMPT_ESCAPES] for more information.
#
#   -- PS1 for current prompt
#   -- PS2 for prompt when awaiting further arguments (i.e. in the middle of a while block).
#   -- RPROMPT for prompt on the right-hand side of the terminal.
# ------------------------------------------------

#PS1="[%n@%m %~]$ "
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# ------------------ Functions -------------------------
# >         (shamelessly copy and pasted)

# For dynamic terminal titles.
function xterm_title_precmd () {
	print -Pn -- '\e]2;%n@%m %~\a'
	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (Eterm*|alacritty*|aterm*|foot*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|wezterm*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

# If a command is not known, use pacman to search for package.
# function command_not_found_handler {
#     local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
#     printf 'zsh: command not found: %s\n' "$1"
#     local entries=(
#         ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"}
#     )
#     if (( ${#entries[@]} ))
#     then
#         printf "${bright}$1${reset} may be found in the following packages:\n"
#         local pkg
#         for entry in "${entries[@]}"
#         do
#             # (repo package version file)
#             local fields=(
#                 ${(0)entry}
#             )
#             if [[ "$pkg" != "${fields[2]}" ]]
#             then
#                 printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
#             fi
#             printf '    /%s\n' "${fields[4]}"
#             pkg="${fields[2]}"
#         done
#     fi
#     return 127
# }

# ------------ Perl stuff, don't touch --------------------
PATH="/home/anapal/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/anapal/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/anapal/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/anapal/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/anapal/perl5"; export PERL_MM_OPT;
source /usr/share/nvm/init-nvm.sh
