export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;33"
export CLICOLOR="auto"

# function parse_git_deleted {
#   [[ $(git status 2> /dev/null | grep deleted:) != "" ]] && echo "-"
# }
# function parse_git_added {
#   [[ $(git status 2> /dev/null | grep "Untracked files:") != "" ]] && echo '+'
# }
# function parse_git_modified {
#   [[ $(git status 2> /dev/null | grep modified:) != "" ]] && echo "*"
# }
# function parse_git_dirty {
#   # [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit (working directory clean)" ]] && echo "☠"
#   echo "$(parse_git_added)$(parse_git_modified)$(parse_git_deleted)"
# }
# function parse_git_branch {
#   git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
# }

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
PS1='\[\033[01;32m\]\u:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 "[%s]")\$ '

source ~/.git_completion.sh
. /etc/bash_completion

if [[ -s /Users/george/.rvm/scripts/rvm ]] ; then source /Users/george/.rvm/scripts/rvm ; fi

alias  findd='find . -type d | egrep -i '
alias  findf='find . -type f | egrep -i '
alias kountd='for f in *; do printf "%30s %5d\n" $f `find $f -type d | wc -l`; done'
alias kountf='for f in *; do printf "%30s %5d\n" $f `find $f -type f | wc -l`; done'

function psg {
  if [ "$1" ] ;
    then ps -ef | grep -v grep  | grep "$1"
    else ps -ef | more
  fi
}

function psga {
    if [ "$1" ] ; then ps -ef | grep -v grep  | grep "$1" | awk '{print $2}'
    fi
}

function psgk {
    if [ "$1" ] ; then ps -ef | grep -v grep  | grep "$1" | awk '{print $2}' | xargs kill
    fi
}

alias env="env | sort"
alias gemi="gem install --no-ri --no-rdoc"
alias gems="cd `rvm gemdir`/gems && ls"
alias projects="cd ~/projects && ls"
alias proj="cd ~/projects && ls"
alias ser="script/server"
alias s="ser"
alias con="script/console"
alias tvim="mvim --remote-tab"

CDPATH=".:~:~/projects:~/projects/abril"
HISTIGNORE="&:ls:[bf]g:exit"
PATH=$PATH:~/.bin

# Oracle Instant Client
export DYLD_LIBRARY_PATH="/opt/oracle_instant_client/instantclient_10_2"
export SQLPATH="/opt/oracle_instant_client/instantclient_10_2"
export TNS_ADMIN="/opt/oracle_instant_client/instantclient_10_2/network/admin"
export NLS_LANG="AMERICAN_AMERICA.UTF8"

export PATH=/usr/local/sbin:/usr/local/bin:$PATH:$DYLD_LIBRARY_PATH
