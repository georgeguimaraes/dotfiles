export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;33"
export CLICOLOR="auto"

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
# PS1='\[\033[01;32m\]\u:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 "[%s]")\$ '
PS1='\[\033[01;32m\]\u:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 "[%s]")\$ '


alias env="env | sort"

CDPATH=".:~:~/projects:~/projects/ptec"
HISTIGNORE="&:ls:[bf]g:exit"
PATH=$PATH:~/.bin

export PATH=/usr/local/sbin:/usr/local/bin:$PATH

# corrects spelling
shopt -s cdspell

# sets a single history for all terminals
shopt -s histappend
history -a

eval "$(rbenv init -)"
