# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias rgrep='rgrep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
elif [ `uname` = "Darwin" ] ; then
    # From grep(1)
    #--colour=[when, --color=[when]]
    alias grep='grep --colour=auto'
    export CLICOLOR=1
fi

# some more ls aliases
alias ll='ls -l'
alias lla='ls -lA'
alias l='ls -CF'
alias la='ls -CFA'

# less typing aliases
alias h='history'

# ifconfig is deprecated
alias ifconfig='ip address show'

# Some more alias to avoid making mistakes:
# alias rm='rm -i'
# alias cp='cp -i'
# alias mv='mv -i'

# For local aliases you don't want checked in
if [ -f ~/.bash_aliases.local ]; then
    . ~/.bash_aliases.local
fi
