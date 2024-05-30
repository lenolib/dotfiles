# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

if [ -n "$BASH_VERSION" ]; then
    # append to the history file, don't overwrite it
    shopt -s histappend

    # check the window size after each command and, if necessary,
    # update the values of LINES and COLUMNS.
    shopt -s checkwinsize
fi

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTFILE=$HOME/.bash_history_nondefault
HISTSIZE=91000
HISTFILESIZE=912000

PROMPT_COMMAND="history -a;$PROMPT_COMMAND"

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

function macvendor () {
    if ! [ -f "/tmp/oui.txt" ]; then
        wget https://raw.githubusercontent.com/royhills/arp-scan/master/ieee-oui.txt -O /tmp/oui.txt
    fi
    OUI=$(echo ${1//[:.- ]/} | tr "[a-f]" "[A-F]" | egrep -o "[0-9A-F]{6}")
    grep $OUI /usr/share/nmap/nmap-mac-prefixes
}
alias macv="python -c \"import sh, sys;fin=[ '\t'.join([ x[0], x[1], str( sh.grep( x[1].upper().replace(':','')[:6], '/tmp/oui.txt', _ok_code=[0,1] ) )[7:] ]) for x in [y.split() for y in sys.stdin.readlines() if y.count(':') > 4]]; print('\n'.join(fin).replace('\n\n', '\n'))\""

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
alias glg_='git log --graph --pretty="format:%C(yellow)%h%Cblue%d%Creset %s %C(white) %an, %ar%Creset"'
alias gdh='git diff HEAD^'
alias gdc='git diff --cached'
alias gsubll='git submodule foreach git pull origin master'
alias gsubup='git submodule foreach --recursive git pull origin master && git submodule foreach --recursive git submodule update'
alias gsu='git submodule update'

# fzf git commit [diff] browser
glg() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

# fzf list and checkout git branches
gren() {
  local branches branch
  branches=$(git branch -vv | while IFS= read li; do x=$(printf "$li" | sed 's/\*//' | awk '{print $2}' | xargs git show --no-patch --date='short' --format='%ad'); printf "$x $li\n"; done | sort | tac)
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | sed "s/\*//" | awk '{print $2}' | sed "s/.* //")
}


alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias lstree="ls -R | grep \":$\" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/   /' -e 's/-/|/'"
alias grepr="grep -Rn"
alias g="grep --color=auto"
alias fat='pygmentize -g'  # Colorized cat
alias ra="ranger"
alias dri='docker run --rm -it '
alias dps='docker ps'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

GIT_BRANCH="git rev-parse --abbrev-ref HEAD 2> /dev/null"
GIT_REMOTE_BRANCH="git rev-parse --symbolic-full-name --abbrev-ref @{u} 2> /dev/null"

if [ -n "$BASH_VERSION" ]; then   
  # Expand aliases by Ctrl+e
  bind '"\C-e": alias-expand-line'
  PS1="\[\033[0;37m\]\342\224\214\342\224\200\$([[ \$? != 0 ]] && echo \"[\[\033[0;31m\]\342\234\227\[\033[0;37m\]]\342\224\200\")\
[$(if [[ ${EUID} == 0 ]]; then echo '\[\033[0;31m\]\h'; else echo '\[\033[1;33m\]\u\[\033[0;37m\]@\[\033[1;96m\]\h'; fi)\
\[\033[0;37m\]]\342\224\200[\[\033[1;32m\]\w\[\033[0;37m\]]\342\224\200[\[\033[1;31m\]\$(${GIT_BRANCH})\
\[\033[0;37m\]->\[\033[1;31m\]\$(${GIT_REMOTE_BRANCH})\[\033[0;37m\]]\342\224\200\$(date +\"%H:%M:%S\")\n\[\033[0;37m\]\342\224\224\342\225\274 \[\033[0m\]"
fi

if [ -n "$ZSH_VERSION" ]; then
setopt PROMPT_SUBST
PROMPT='┌─[%(?.%F{green}√.%F{red}?%?)%f]─[%F{yellow}%n%f@%F{cyan}%m%f]─[%B%F{green}%1~%f%b]─[%F{red}$(git rev-parse --abbrev-ref HEAD 2> /dev/null)->$(git rev-parse --symbolic-full-name --abbrev-ref @{u} 2> /dev/null)%f]-$(date +"%H:%M:%S") 
└╼ '
ZSH_DISABLE_COMPFIX="true";
autoload -Uz compinit; compinit;
bindkey "^e" _expand_alias;
bindkey '^u' beginning-of-line
bindkey '^o' end-of-line
fi

alias mosh="mosh --server='mosh-server new -l LC_ALL=en_US.UTF-8'"
alias rednose='nosetests --rednose'
alias p8="ping 8.8.8.8"

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
function d () { cd "$1"; ls -la; }

# Shorthand for redirecting stderr to stdout
alias err=" 2>&1 "
alias here='2>&1 | grep --color -E "$(pwd).*|\$"'

# Shorthand for finding
function hit () { arg2=$2; find . -maxdepth ${arg2:=999} -type f -iname "*$1*" | grep -i "$1"; }
function hitdir () { arg2=$2; find . -maxdepth ${arg2:=999} -type d -iname "*$1*" | grep -i "$1"; }
function fin () { grep -n "$1" $(find . -type f -name "*$2*"); }

# Replace a string in non-hidden files
function replacer () {
    if [[ -z "$1" ]]; then
        echo "Function requires at least one argument"
        return 1
    fi
    files=`find . \( ! -regex '.*/\..*' \) -name "*" -type f -exec grep -l "$1" {} +`;
    if [[ -z "$files" ]]; then
        echo "No files found containing '$1'"
        return 0
    fi
    echo "Files containing '$1':"
    echo "------"
    echo "$files"
    echo "------"
    read -p ">>> Replace '$1' --> '$2' in the above files? [Y/n]: " RESP;
    if [[ "$RESP" == "y" || "$RESP" == "Y" || "$RESP" == "" ]]; then
        echo "$files" | xargs sed -i "s/$1/$2/g"
    fi
}

# Find python imports in current directory that are not part of the python standard library
function non-stdlib-imports () {
    # Requires isort to be pip-installed
    stdlib_mods=`python -c "import isort, sys; sys.stdout.write('|'.join(isort.settings.default['known_standard_library']))"`
    non_stdlib_used_mods=`grep "import " $(find . -name "*.py") | cut -f2 -d ' ' | cut -f1 -d'.' | sort | uniq | grep -v -E $stdlib_mods`
    grep -nRE "$non_stdlib_used_mods" | grep -e "import.* " -e "from.* "
}


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
#function hgrep () { history | grep -P -- "$1" | grep -P -- "$2" | grep -P -- "$3"; }
function hgrep () { ( cat --number $HOME/.bash_history_2016-10-30; history; ) | grep -P -- "$1" | grep -P -- "$2" | grep -P -- "$3"; }
function outdated_reqs () {
  echo "Checking installed outdated modules in $1 ..."
  local modules=$(cat $1 | sed 's/==.*//' | sed -e '{:q;N;s/\n/\|/g;t q}')
  pip list --outdated 2>/dev/null | grep -i -E $modules
}
function sshrc () { /usr/bin/ssh -t $* "echo '`base64 -i ~/.bash_remote_rc`' | base64 --decode > /tmp/bash_remote_rc; bash --rcfile /tmp/bash_remote_rc" 
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

function jwt-decode() { sed 's/\./\n/g' <<< $(cut -d. -f1,2 <<< $1) | base64 --decode | jq; }

function decodeBase64 () { echo "$1" | base64 -d; echo ""; }

function stamp () { date -d @$1; }


# ls variation aliases
alias ll='ls -alFG'
alias la='ls -A'
alias lh='ls -lFh'
alias l='ls -lFG'
alias lsize='ls -lAhr --sort=size'
export LSCOLORS=Exfxcxdxbxegedabagacad;


# ls Attribute	Foreground color	Background color
# directory	e	x
# symbolic	f	x
# socket	c	x
# pipe	d	x
# executable	b	x
# block	e	g
# character	e	d
# executable	a	b
# executable	a	g
# directory	a	c
# directory	a	d
# The color and their code values are as follows:

# Code	Meaning (Color)
# a	Black
# b	Red
# c	Green
# d	Brown
# e	Blue
# f	Magenta
# g	Cyan
# h	Light grey
# A	Bold black, usually shows up as dark grey
# B	Bold red
# C	Bold green
# D	Bold brown, usually shows up as yellow
# E	Bold blue
# F	Bold magenta
# G	Bold cyan
# H	Bold light grey; looks like bright white
# x	Default foreground or background

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

alias xm='xmodmap modmap && exit'
alias xin='sudo xinput set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Finger" 38, 43, 0 && sudo xinput set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Area" 1500, 4600, 2400, 0 && sudo xinput set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Noise Cancellation" 12, 12 && sudo xinput set-prop "SynPS/2 Synaptics TouchPad" "Synaptics Soft Button Areas" 3650, 4826, 0, 2400, 0, 0, 0, 0 && sudo xinput set-prop "SynPS/2 Synaptics TouchPad" "Device Accel Profile" 1'

#if [ -d $HOME/.homesick ]; then
    #source $HOME/.homesick/repos/homeshick/homeshick.sh
#fi

function hostgrep () { cat ~/.ssh/config | grep -P -A1 $1 | grep -A1 $2 | grep -v '\-\-' | tee /dev/fd/2 | grep -v "Host " | awk '{print $2}'; }

#if [ -f "$HOME/google-cloud-sdk/path.bash.inc" ]; then
#    # The next line updates PATH for the Google Cloud SDK.
#    source "$HOME/google-cloud-sdk/path.bash.inc"
#    # The next line enables bash completion for gcloud.
#    source "$HOME/google-cloud-sdk/completion.bash.inc"
#fi
export PATH=$PATH:$HOME/opt/terraform
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:/usr/local/opt/libpq/bin

#alias vew='source $HOME/.local/bin/virtualenvwrapper.sh'
#source $HOME/.local/bin/virtualenvwrapper_lazy.sh
       
export FZF_CTRL_R_OPTS='--sort'
if [ -n "$BASH_VERSION" ]; then
    [ -f ~/.fzf.bash ] && source ~/.fzf.bash
    bind '"\C-r": reverse-search-history' 
    bind '"\C-n": " \C-e\C-u`__fzf_history__`\e\C-e\e^\er"'
    __fzf_history__() (
    local line
    shopt -u nocaseglob nocasematch
    all_hist=$( HISTTIMEFORMAT= cat -n ~/.bash_history_2016-10-30; history; )
    line=$(
        HISTTIMEFORMAT=  echo "$all_hist" |
        eval "fzf +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r $FZF_CTRL_R_OPTS" |
        command grep '^ *[0-9]') &&
        if [[ $- =~ H ]]; then
        sed 's/^ *\([0-9]*\)\** *//' <<< "$line"
        #sed 's/^ *\([0-9]*\)\** .*/!\1/' <<< "$line" 
        else
        sed 's/^ *\([0-9]*\)\** *//' <<< "$line"
        fi
    )
fi

if [ -f $HOME/.hub.bash_completion.sh ]; then
  . $HOME/.hub.bash_completion.sh
fi


# fco - checkout git branch/tag
fco() {
  local tags branches target
  tags=$(
    git tag | awk '{print "\x1b[31;1mtag\x1b[m\t" $1}') || return
  branches=$(
    git branch --all | grep -v HEAD             |
    sed "s/.* //"    | sed "s#remotes/[^/]*/##" |
    sort -u          | awk '{print "\x1b[34;1mbranch\x1b[m\t" $1}') || return
  target=$(
    (echo "$tags"; echo "$branches") |
    fzf-tmux -l30 -- --no-hscroll --ansi +m -d "\t" -n 2) || return
  git checkout $(echo "$target" | awk '{print $2}')
}

# https://github.com/sindresorhus/guides/blob/master/npm-global-without-sudo.md
#NPM_PACKAGES="${HOME}/.npm"
#PATH="$NPM_PACKAGES/bin:$PATH"


# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.bash.inc" ];
then . "$HOME/Downloads/google-cloud-sdk/path.bash.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.bash.inc" ];
then . "$HOME/Downloads/google-cloud-sdk/completion.bash.inc"; fi

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
