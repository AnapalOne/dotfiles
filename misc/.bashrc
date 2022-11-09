#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#alias ls='ls --color=auto'

export PATH=$PATH:/usr/local/bin

export VISUAL="subl"

alias reboot='sudo systemctl reboot'
alias shutdown='sudo systemctl poweroff'
alias hibernate='sudo systemctl hibernate'

#alias ls='nnn -de'
#alias nnn='nnn -de'
#alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
#alias ls='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias ls='source ranger'
#alias spt='~/Scripts/spt-spotifyd'

#perl things
PATH="/home/anapal/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/anapal/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/anapal/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/anapal/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/anapal/perl5"; export PERL_MM_OPT;
