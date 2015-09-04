# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=91000
HISTFILESIZE=912000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Git aliases
alias gs='git status'
alias gl='git log '
alias glp='git log -p '
alias gf='git fetch '
alias gfa='git fetch --all'
alias gfu='git fetch upstream'
alias gll='git pull '
alias gpu='git push '
alias gd='git diff '
alias gds='git diff --stat'
alias gdum='git diff upstream/master'
alias gfdum='git fetch upstream && git diff upstream/master'
alias gsl='git stash list'
alias gsa='git stash apply'
alias gch='git checkout '
alias gr='git remote '
alias gb='git branch '
alias gchum='git checkout upstream/master'
alias gchm='git checkout master'
alias gllu='git pull upstream'
alias gllum='git pull upstream master'
alias gap='git add --patch'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias glg='git log --graph --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset"'
alias gdh='git diff HEAD^'
alias gdc='git diff --cached'
alias gsubll='git submodule foreach git pull origin master'
alias gsubup='git submodule foreach --recursive git pull origin master && git submodule foreach --recursive git submodule update'


alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias lstree="ls -R | grep \":$\" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias grepr="grep -R"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

GIT_BRANCH="git rev-parse --abbrev-ref HEAD 2> /dev/null"
GIT_REMOTE_BRANCH="git rev-parse --symbolic-full-name --abbrev-ref @{u} 2> /dev/null"

PS1="\[\033[0;37m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]\342\224\200\")[$(if [[ ${EUID} == 0 ]]; then echo '\[\033[0;31m\]\h'; else echo '\[\033[1;33m\]\u\[\033[0;37m\]@\[\033[1;96m\]\h'; fi)\[\033[0;37m\]]\342\224\200[\[\033[1;32m\]\w\[\033[0;37m\]]\342\224\200[\[\033[1;31m\]\$(${GIT_BRANCH})\[\033[0;37m\]->\[\033[1;31m\]\$(${GIT_REMOTE_BRANCH})\[\033[0;37m\]]\342\224\200\n\[\033[0;37m\]\342\224\224\342\225\274 \[\033[0m\]"

alias mosh="mosh --server='mosh-server new -l LC_ALL=en_US.UTF-8'"
alias rednose='nosetests --rednose'

# Package manager aliases
alias sap="sudo apt-get "
alias sapi="sudo apt-get install "
alias sapu="sudo apt-get update"
# Tmux aliases
alias td="tmux detach"
alias ta="tmux a"
alias tls="tmux list-sessions"
# Shorthand for moving up file tree
alias f='cd ..'
# Shorthand for returning to previous directory
alias c='cd -'

# Shorthand for trash, which also of course can be used in place of rm -r
alias rem='trash'
# Trash all pyc-files in directory and sub-directories
alias rempyc='find . -name "*.pyc" | xargs trash'
# Open file from the command line with the program associated with the filetype
alias op='xdg-open'
# Display nice-looking calendar
alias cal='ncal -bM'

# Command for stripping trailing white spaces in file
alias rm_trail_wp="sed --in-place 's/[[:space:]]\+$//'"

COL_RED='\033[1;31m'
NOCOLOR='\033[0m'

# source ~/.bash_alias_completion
function clrdiff () { colordiff -y -W $(tput cols) "$@" | less -R;}
function hgrep () { history | grep -P -- "$*"; }
function outdated_reqs () {
  echo "Checking installed outdated modules in $1 ..."
  local modules=$(cat $1 | sed 's/==.*//' | sed -e '{:q;N;s/\n/\|/g;t q}')
  pip list --outdated 2>/dev/null | grep -i -E $modules
} 

eval 'map () {    if [ $# -le 1 ]; then      return ;   else      local f=$1 ;     local x=$2 ;     shift 2 ;     local xs=$@ ;      eval $f $x ;      map "$f" $xs ;   fi ; }'
dirfunc () { 
    orgpwd=`pwd`
    echo ""
    echo -e "$COL_RED---------> $2 <---------$NOCOLOR"
    cd $2
    eval $func $1
    cd $orgpwd
}


# ls variation aliases
alias ll='ls -alF'
alias la='ls -A'
alias lh='ls -lFh'
alias l='ls -lF'
alias lsize='ls -lAhr --sort=size'

# ----------------------------------
# Display ls filesizes with decimals
# ----------------------------------
lsMB="--color=always | awk ""'"'BEGIN{mega=1048576} { sz = sprintf("%0.3f", $5/mega)} {gsub("^0*", "", sz)} {$1 = sprintf("%s %+3s %-8s %-8s %+9s M %+3s %+2s %+5s ", $1, $2, $3, $4, sz, $6, $7, $8)} {$2=""}{$3=""}{$4=""}{$5=""}{$6=""}{$7=""}{$8=""}{print}'"'"
lsKB="--color=always | awk ""'"'BEGIN{kilo=1024} { sz = sprintf("%0.3f", $5/kilo)} {gsub("^0*", "", sz)} {$1 = sprintf("%s %+3s %-8s %-8s %+12s K %+3s %+2s %+5s ", $1, $2, $3, $4, sz, $6, $7, $8)} {$2=""}{$3=""}{$4=""}{$5=""}{$6=""}{$7=""}{$8=""}{print}'"'"
alias lk="ls -l $lsKB"
alias lks="ls -l -r --sort=size $lsKB"
alias lksr="ls -l --sort=size $lsKB"
alias lm="ls -l $lsMB"
alias lms="ls -l -r --sort=size $lsMB"
alias lmsr="ls -l --sort=size $lsMB"


# -----------------------------------------------------------------------------------
# User-specific and more opinionated settings (delete if undesired or malfunctioning)
# -----------------------------------------------------------------------------------
export PATH=$PATH:$HOME/.local/bin
source $HOME/.homesick/repos/homeshick/homeshick.sh
ulimit -c unlimited

# The next line updates PATH for the Google Cloud SDK.
source "$HOME/google-cloud-sdk/path.bash.inc"
# The next line enables bash completion for gcloud.
source "$HOME/google-cloud-sdk/completion.bash.inc"

alias xm='xmodmap modmap && exit'
alias xin='sudo xinput set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Finger" 38, 43, 0 && sudo xinput set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Area" 1500, 4600, 2400, 0 && sudo xinput set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Noise Cancellation" 12, 12 && sudo xinput set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Soft Button Areas" 3650, 4826, 0, 2400, 0, 0, 0, 0 && sudo xinput set-prop "SynPS/2 Synaptics TouchPad" "Device Accel Profile" 1'
alias xbl='rfkill unblock all && sleep 1 &&  nmcli con up uuid da4fbe88-0999-4e31-bcfb-4e6848d69d0d && exit'
alias xwl='nmcli con up id "LiPhone" && exit'

