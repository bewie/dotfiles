# Fichier .zshrc pour ZSH
# (C) Laurent (laurent@bewie.org)
##


[[ -z $OSTYPE ]] && OSTYPE=`uname`
[[ -z $HOSTTYPE ]] && HOSTTYPE=$MACHTYPE

print -n "[ Loading : rc"
RCLOADED=1

#----------------{ Options
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000
export PATH="$HOME/bin:/usr/local/sbin:$PATH"
unsetopt cshjunkiequotes                 # On est sous ZSH merde,c'est bapt qui l'dit alors j'lecoute !
export EDITOR=/usr/bin/vi		 # vi off course!
setopt ALL_EXPORT                        # Exporte tout
setopt ALWAYS_TO_END                     # Saute apres le mot si completion
setopt MAIL_WARNING                      # Verification modifs des mails
setopt MARK_DIRS                         # Ajoute un / apres les repertoires
setopt NO_BEEP                           # Silence
unsetopt RM_STAR_SILENT                  # Protection du rm *

setopt HIST_NO_STORE                     # N'enregistre pas la cmd history
setopt appendhistory extendedglob nomatch notify
setopt hist_ignore_all_dups
#---- }

#----------------{ oh-my-zsh
export ZSH=$HOME/.oh-my-zsh

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git atom rake tmux cp git-prompt)

source $ZSH/oh-my-zsh.sh

#----------------{ antigen
#https://github.com/arialdomartini/oh-my-git
source "$HOME/.antigen/antigen.zsh"
antigen-use oh-my-zsh
antigen-bundle arialdomartini/oh-my-git

autoload -U zfinit
zfinit
autoload -U zmv  # load the ZSH super mv ;)


#----------------{ Completion
print -n " complete"

compctl -u finger -- talk -- ytalk
compctl -O print
compctl -E echo
compctl -u -x 's[+] c[-1,-f],s[-f+]' -g '~/Mail/*(:t)' - 's[-f],c[-1,-f]' -f -- mail -- Mail -- elm -- pine
compctl -e which -- where -- whence

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$user_color%B%d%b$end"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:corrections' format "$user_color%B%d (erreurs: %e)%b$end"
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                             /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*' group-name ''

#Utilisation du cache
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path ~/.zsh/cache

# des couleurs pour la complÃ©tion
#zmodload zsh/complist
#setopt extendedglob
#couleur dans le kill
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=36=31"
##
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' verbose yes
#zstyle ':completion:*' list-colors ''
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' '*?.pl~' '*?.erl~' \
    '*?.old' '*?.dis' '*?.bck'
#completion sur le local directory puis sur le cdpath pour la commande cd
zstyle ':completion:*:*:cd:*' tag-order local-directories path-directories

zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s

# Completion ssh en fonction des known_hosts bien pratique a meetic..
local _myhosts
if [ -d ~/.ssh ]; then
        if [ -f ~/.ssh/known_hosts ];then
                _myhosts=(${=${${(f)"$(<$HOME/.ssh/known_hosts)"}%%[# ]*}//,/ })
         fi
fi
zstyle ':completion:*' hosts $_myhosts

#zstyle :compinstall filename '/home/laurent/.zshrc'
#Pas trop compris a quoi ca sert...
zstyle ':completion:*' special-dirs true


autoload -U compinit
compinit

#----------------{ Bindkey
print -n " bind"
typeset -g -A key
bindkey '^I' complete-word # complete on tab, leave expansion to _expand
#WORDCHARS=${WORDCHARS//[&=\/;!#%{]}
#WORDCHARS=${WORDCHARS//[&=\  ;!#%{]}
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
#bindkey -v
bindkey -e
bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char
#
# Useful piping shortcuts
#bindkey -s '^|l' "|less\n"                   # c-| l  pipe to less
#bindkey -s '^|g' '|grep ""^[OD'             # c-| g  pipe to grep
#bindkey -s '^|a' "|awk '{print $}'^[OD^[OD"  # c-| a  pipe to awk
#bindkey -s '^|s' '|sed -e "s///g"^[OD^[OD^[OD^[OD' # c-| s  pipe to sed
#
# Input controls
bindkey '^[[1;3D' backward-word    # alt + LEFT
bindkey '^[[1;3C' forward-word     # alt + RIGHT
bindkey '_^?' backward-delete-word # alt + BACKSPACE  delete word backward
bindkey '^[[3;3~' delete-word      # alt + DELETE  delete word forward
bindkey '^[' self-insert           # alt + ENTER  allow multiline input
#bindkey '_t' transpose-words

bindkey '^[[F' end-of-line
bindkey '^[[H' beginning-of-line
bindkey '^Z' beginning-of-line	#
bindkey '^E' end-of-line	#Ouais normalement c'est A/Z mais dans screen c'est relou...
bindkey '^R' history-incremental-search-backward
bindkey ' ' magic-space

# edit commandline with your favorite ($FCEDIT)or
autoload edit-command-line
zle -N edit-command-line
##



#----------------{ Run-help
[ ! -x `alias run-help` ] && unalias run-help
autoload run-help # ESC-h, ESC-H, ALT-h ou ALT-H lance le man sur la commande en cours.


#----------------{ Alias
#
print -n " alias"

case $OSTYPE in
darwin*)
	alias ls="ls -G"
;;
freebsd*)
	alias ls="ls -G"
;;
linux*)
	alias ls="ls --color=auto"
;;
esac
alias a="alias"

a rm='rm -f'
a xterm="xterm $XTERM_OPTS"
a l='ls -l'
a ll='ls -al'
# List only directories and symbolic
# links that point to directories
a lsd='ls -ld *(-/DN)'
# List only file beginning with "."
a lsa='ls -ld .*'
# Nettoye de maniere recursive depuis l'abrorescence courante
a rpurge='rm -vf **/(*(.old|.OLD|~|.tmp|%|.clz|.toc|%|.bak)|.nfs*|core|\#*|\~\$*)(D.)'
# Nettoye l'abro courante (non recursif)
a purge='rm -vf (*(.old|.OLD|~|.tmp|%|.clz|.toc|%|.bak)|.nfs*|core|\#*|\~\$*)(D.)'
# Supprime de maniere recursive les rep vides
a rpurgedir='rmdir -v **/*(D/^F)'
# Supprime de manire recursive les fichiers vides
a rpurgefiles='rm -vf *(D.L0)'
# Supprime de non manire recursive les fichiers vides
a purgefiles='rm -vf *(D.L0)'
a cp='cp -p'
a mv='mv -i'
#contre les boulettes
a cd..='cd \.\.'
a sl=ls
a rights='chmod 755 **/*(/) & chmod 644 **/*(.)'
a rh='sync;rehash;sync'
a h='history | less'
a j='jobs -l'
# Quick chmod ;-)
a rw-='chmod 600'
a rwx='chmod 700'
a r--='chmod 644'
a r-x='chmod 755'
a fuck='sudo $(fc -ln -1)'

alias zshconfig="atom ~/.zshrc"
alias ohmyzsh="atom ~/.oh-my-zsh"


alias grep="grep --color=auto"
alias vkern="printf 'GET /kdist/finger_banner HTTP1.0\n\n' | nc www.kernel.org 80 | grep latest"
alias freenode="irssi --nick=bewie --connect=irc.freenode.net"
alias iguaneirc="irssi --nick=lolo --connect=irc.dedibox.fr"

#config boulo
alias dell_dock="xrandr --output DVI1 --mode 1280x1024 --rate 75 --pos 0x0 --rotate normal --output DVI2 --mode 1280x1024 --rate 75 --pos 1280x0 --rotate normal --output LVDS1 --off"
#alias dell_dock="xrandr --output DVI1 --mode 1280x1024 --pos 0x0 --rotate normal --output DVI2 --mode 1280x1024 --pos 1280x0 --rotate normal --output LVDS1 --off"
alias laptop="xrandr --output DVI1 --off --output DVI2 --off --output LVDS1 --mode 1440x900 --pos 0x0 --rotate normal"
alias ffig1='/Applications/Firefox.app/Contents/MacOS/firefox-bin -P IG1 -no-remote'
alias fflaurent='/Applications/Firefox.app/Contents/MacOS/firefox-bin -P Laurent -no-remote'
alias todo="/Users/laurent/git/todo.txt-cli/todo.sh"

#alias puppet-lint="puppet-lint --no-80chars-check --no-documentation-check --no-autoloader_layout-check --no-nested_classes_or_defines-check --no-class_inherits_from_params_class-check"

_src_etc_profile_d()
{
    #  Make the *.sh things happier, and have possible ~/.zshenv options like
    # NOMATCH ignored.
    emulate -L ksh
    # from bashrc, with zsh fixes
    if [[ ! -o login ]]; then # We're not a login shell
        for i in /home/laurent/.SH_SOURCES/*.sh; do
            if [ -r "$i" ]; then
                . $i
            fi
        done
        unset i
    fi
}
_src_etc_profile_d


zmodload zsh/complist
autoload -U zcalc

if [[ "$TERM" == "xterm" ]]; then # We're not a login shell
  export TERM=xterm-256color
fi

#----------------{ prompt
print -n " prompt"

function powerline_precmd() {
  export PS1="$(~/powerline-shell.py $? --shell zsh 2> /dev/null)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

# Set prompts
#autoload -U promptinit
#autoload -Uz vcs_info && vcs_info
#zstyle ':vcs_info:*:prompt:*' check-for-changes true


#promptinit
#prompt redhat
#PROMPT='%B%F{red}%m%k %B%F{blue}%1~ %# %b%f%k'
#PROMPT='%B%F{green}%n@%m%k %B%F{blue}%1~ %# %b%f%k'
if [[ "$EUID" = "0" ]] || [[ "$USER" = 'root' ]]
  then
    PROMPT='%(?..[%F{red}%?%b%f%k])%F{red}%n%F{green}@%m%k %B%F{blue}%1~> %b%f%k'
else
  if [[ -x ~/powerline-shell.py ]]
    then
      install_powerline_precmd
    else
      PROMPT='%(?..[%F{red}%?%b%f%k])%F{blue}%n%F{green}@%m%k %B%F{blue}%1~> %b%f%k'
  fi
fi
#pantigen theme arialdomartini/oh-my-git-themes oppa-lana-style
#antigen theme robbyrussell/oh-my-zsh themes/bureau


#----------------{ hash
print -n " hash"
case $OSTYPE in
freebsd*)
        hash -d ports=/usr/ports
        hash -d src=/usr/src
;;
linux*)
        hash -d src=/usr/src/linux
        [[ -f /etc/gentoo-release ]] && hash -d portage=/usr/portage
;;
esac

print -n " ]"

print
antigen-apply

#----------------{ Golang
# Setup Go workspaces
_root_go_workspaces=$HOME/Go-Workspaces
function _golang_normalize_env {
    if [ "${${:-$GO_ENV}[-1]}" = "/" ]; then
        export GO_ENV=${GO_ENV:0:${#GO_ENV}-1}
    elif [ -z "$GO_ENV" ]; then
        export GO_ENV="${_root_go_workspaces}";
    fi

    if [ ! -d "$GO_ENV" ]; then
        mkdir "$GO_ENV"
    fi
}

function go_workon {
    if [ -z "$1" ]; then
        printf "Specify a workspace to work with\n";
        return 1
    fi

    _golang_normalize_env;
    GOPATH=$(printf "$GO_ENV/$1\n")

    if [ -z "$_GOENV_OLD_PATH" ]; then
        # We have no old path - we can undonditionally set it
        _GOENV_OLD_PATH="$PATH"
    fi

    PATH=$_GOENV_OLD_PATH:$GOPATH/bin

    if [ -d "$GOPATH" ]; then
        export GOPATH
        export PATH
        printf "GOPATH => %s\nPATH => %s\n" $GOPATH $PATH

        # Update prompt:
        if [ -z "${VIRTUAL_ENV_DISABLE_PROMPT-}" ] ; then
          _OLD_VIRTUAL_PS1="$PS1"
          if [ "x" != x ] ; then
            PS1="$PS1"
          else
            PS1="(`basename \"$GOPATH\"`)$PS1"
          fi
          export PS1
        fi
    else
        #printf 'No directory found for $GOPATH. Has it been created with 'mk_go_workspace'?\n'
        #return 1
        mk_go_workspace $1
    fi

  cd $GOPATH
}

function mk_go_workspace {
    if [ -z $1 ]; then
        printf "Specify a workspace name\n";
        return 1
    fi

    _golang_normalize_env;

    if [ ! -d $GO_ENV/$1 ]; then
        ws_name=$1;

        pushd $GO_ENV > /dev/null;
        mkdir -p $ws_name/{bin,pkg,src}
        go_workon $1
        popd > /dev/null;
    else
        printf "Workspace '$1' already exists!\n"
        return 1
    fi
}

# Todo remove prompt workspace name.
function go_deactivate {
    if [ -n "$_GOENV_OLD_PATH" ]; then
        PATH="$_GOENV_OLD_PATH"
        export PATH
    fi

    unset GOPATH
}

alias gotest="go test -v -covermode=count"
alias gocover="go test -covermode=count -coverprofile=profile.out"

function gocoverhtml {
    if [ -e "profile.out" ]; then
        go tool cover -html=profile.out
    else
        gocover && go tool cover -html=profile.out && rm profile.out
    fi
}
