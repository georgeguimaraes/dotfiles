export GREP_OPTIONS="--color=auto"
export GREP_COLOR="4;33"
export CLICOLOR="auto"
export EDITOR="vim -f"

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
PS1='\[\033[01;32m\]\u:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 "[%s]")\$ '

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

alias env="env | sort"

alias pg_start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pg_stop='pg_ctl -D /usr/local/var/postgres stop -s -m fast'
alias redis="redis-server /usr/local/etc/redis.conf"
alias memcached="memcached -vv"

alias gclone='git clone'
alias gci='git commit'
alias gcia='git commit -a'
alias gpu='git push'
alias gpl='git pull'
alias gs='git status'
alias gd='git diff'
alias g='git'
alias ga='git add'

alias bi="bundle install"
alias bu="bundle update"
alias be="bundle exec"

alias gitconfig='mvim ~/.gitconfig'
alias bashconfig='mvim ~/.bash_profile'
alias sshconfig='mvim ~/.ssh/config'
alias hosts='sudo mvim /etc/hosts'
alias vimdir='cd ~/.vim; mvim -c "cd ~/.vim" ~/.vim'
alias v='mvim'
alias json=json_reformat
alias grep="grep -i"
alias htop="sudo htop"

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ll='ls -FGlAhp'                       # Preferred 'ls' implementation
alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview

CDPATH=".:~:~/code:~/code/ptec"
HISTIGNORE="&:ls:[bf]g:exit"
export PATH=/usr/local/sbin:/usr/local/bin:~/bin:$PATH

shopt -s cdspell

# sets a single history for all terminals
shopt -s histappend
history -a

eval "$(rbenv init -)"

export DISABLE_SPRING=1

export EXENV_ROOT=/usr/local/var/exenv
if which exenv > /dev/null; then eval "$(exenv init -)"; fi

export ERL_AFLAGS="-kernel shell_history enabled"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/george/google-cloud-sdk/path.bash.inc' ]; then . '/Users/george/google-cloud-sdk/path.bash.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/george/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/george/google-cloud-sdk/completion.bash.inc'; fi

