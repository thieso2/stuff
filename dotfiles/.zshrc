#!/bin/zsh
#
# .zshrc
# for zsh 3.1.6 and newer (may work OK with earlier versions)
#
# by Adam Spiers <adam@spiers.net>
#
# Best viewed in emacs folding mode (folding.el).
# (That's what all the # {{{ and # }}} are for.)
#
# $Id: .zshrc,v 1.174 2002/06/29 10:31:31 adams Exp $
#
# found on http://adamspiers.org/computing/zsh/files/.zshrc
# and slightly adapted by Florian Lanthaler
# Adam's version worked nicely, so I'm to blame for any
# errors in this file :)
#

# start user env
export CVS_RSH=ssh
export CVSROOT=/home/cvs

export LC_ALL=de_DE.UTF-8

export ORACLE_SID=TC92
export ORACLE_HOME=/home/oracle9/9.2.0.1
#export NLS_LANG=.UTF8
export NLS_LANG=american_america.WE8ISO8859P1
#export NLS_LANG=german_germany.WE8ISO8859P9
#export NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS'
export NLS_DATE_FORMAT='DD.MM.YYYY HH24:MI:SS'
export ORA_NLS32=$ORACLE_HOME/ocommon/nls/admin/data
export ORA_NLS33=$ORACLE_HOME/ocommon/nls/admin/data

export DCARCH=linux

# end user env

export QT_XFT=true

# {{{ To do list

#
#    - du1
#    - Add prot and unprot
#    - Do safes?kill(all)? functions
#

# }}}

# {{{ What version are we running?

if ! (( $+ZSH_VERSION_TYPE )); then
  if [[ $ZSH_VERSION == 3.0.<->* ]]; then ZSH_STABLE_VERSION=yes; fi
  if [[ $ZSH_VERSION == 3.1.<->* ]]; then ZSH_DEVEL_VERSION=yes;  fi

  ZSH_VERSION_TYPE=old
  if [[ $ZSH_VERSION == 3.1.<6->* ||
        $ZSH_VERSION == 3.<2->.<->*  ||
        $ZSH_VERSION == 4.<->* ]]
  then
    ZSH_VERSION_TYPE=new
  fi
fi

# }}}
# {{{ Profiling

[[ -n "$ZSH_PROFILE_RC" ]] && which zmodload >&/dev/null && zmodload zsh/zprof

# }}}
# {{{ Loading status

zshrc_load_status () {
  # \e[0K is clear to right
  echo -n "\r.zshrc load: $* ... \e[0K"
}

# }}}

# {{{ simple functions to make life easy
p () {
	ps aux
}

# {{{ Options

zshrc_load_status 'setting options'

setopt                       \
     NO_all_export           \
        always_last_prompt   \
     NO_always_to_end        \
        append_history       \
     auto_cd              \
        auto_list            \
        auto_menu            \
     NO_auto_name_dirs       \
        auto_param_keys      \
        auto_param_slash     \
        auto_pushd           \
     NO_auto_resume          \
        bad_pattern          \
        bang_hist            \
     NO_beep                 \
        brace_ccl            \
        correct_all          \
     NO_bsd_echo             \
        cdable_vars          \
     NO_chase_links          \
     NO_clobber              \
        complete_aliases     \
        complete_in_word     \
     NO_correct              \
        correct_all          \
        csh_junkie_history   \
     NO_csh_junkie_loops     \
     NO_csh_junkie_quotes    \
     NO_csh_null_glob        \
        equals               \
        extended_glob        \
        extended_history     \
        function_argzero     \
        glob                 \
     NO_glob_assign          \
        glob_complete        \
     NO_glob_dots            \
        glob_subst           \
        hash_cmds            \
        hash_dirs            \
        hash_list_all        \
        hist_allow_clobber   \
        hist_beep            \
        hist_ignore_dups     \
        hist_ignore_space    \
     NO_hist_no_store        \
        hist_verify          \
     NO_hup                  \
     NO_ignore_braces        \
     NO_ignore_eof           \
        interactive_comments \
     NO_list_ambiguous       \
     NO_list_beep            \
        list_types           \
        long_list_jobs       \
        magic_equal_subst    \
     NO_mail_warning         \
     NO_mark_dirs            \
     NO_menu_complete        \
        multios              \
        nomatch              \
        notify               \
     NO_null_glob            \
        numeric_glob_sort    \
     NO_overstrike           \
        path_dirs            \
        posix_builtins       \
     NO_print_exit_value     \
     NO_prompt_cr            \
        prompt_subst         \
        pushd_ignore_dups    \
     NO_pushd_minus          \
        pushd_silent         \
        pushd_to_home        \
        rc_expand_param      \
     NO_rc_quotes            \
     NO_rm_star_silent       \
     NO_sh_file_expansion    \
        sh_option_letters    \
        short_loops          \
     NO_sh_word_split        \
     NO_single_line_zle      \
     NO_sun_keyboard_hack    \
        unset                \
     NO_verbose              \
        zle

if [[ $ZSH_VERSION_TYPE == 'new' ]]; then
  setopt                       \
        hist_expire_dups_first \
        hist_ignore_all_dups   \
     NO_hist_no_functions      \
     NO_hist_save_no_dups      \
        inc_append_history     \
        list_packed            \
     NO_rm_star_wait
fi

if [[ $ZSH_VERSION == 3.0.<6->* || $ZSH_VERSION_TYPE == 'new' ]]; then
  setopt \
        hist_reduce_blanks
fi

# }}}
# {{{ Environment

zshrc_load_status 'setting environment'

# {{{ INFOPATH

[[ "$ZSH_VERSION_TYPE" == 'old' ]] || typeset -T INFOPATH infopath
typeset -U infopath
export INFOPATH
infopath=( 
          ~/local/info(N)
          /usr/info(N)
          $infopath
         )

# }}}

# Variables used by zsh

# {{{ Function path

fpath=(
       $zdotdir/{.[z]sh/*.zwc,{.[z]sh,[l]ib/zsh}/{functions,scripts}}(N) 

       $fpath

       # very old versions
       /usr/doc/zsh*/[F]unctions(N)
      )

# Autoload all shell functions from all directories in $fpath that
# have the executable bit on (the executable bit is not necessary, but
# gives you an easy way to stop the autoloading of a particular shell
# function).

for dirname in $fpath; do
  fns=( $dirname/*~*~(N.x:t) )
  (( $#fns )) && autoload "$fns[@]"
done

#[[ "$ZSH_VERSION_TYPE" == 'new' ]] || typeset -gU fpath

# }}}
# {{{ globish options 

WORDCHARS=''
EXTENDED_GLOB=1

# }}}
# {{{ I like my CSH/TCSH
CSH_NULL_GLOB=1
MARK_DIRS=1
# }}}
# {{{ Save a large history

HISTFILE=~/.zshhistory
HISTSIZE=3000
SAVEHIST=3000
HIST_EXPIRE_DUPS_FIRST=1
APPEND_HISTORY=1
INC_APPEND_HISTORY=1

# }}}
# {{{ Maximum size of completion listing

# Only ask if line would scroll off screen
LISTMAX=0

# }}}
# {{{ Watching for other users

LOGCHECK=60
WATCHFMT="[%B%t%b] %B%n%b has %a %B%l%b from %B%M%b"

# }}}

# {{{ Java environment variables

export JAVA_HOME=/usr/lib/j2se/1.4/
#export CLASSPATH=""

# }}}

path=(/usr/lib/java/bin $path)
path=(/usr/local/kde/bin $path)
path=($path /sbin/ /usr/sbin/)
path=($path /usr/lib/java/ant/bin)


# }}}

# }}}
# {{{ Prompts

PS1='%n@%m%# ' ## date/time
RPS1=$'%{\e[0;31m%}%4~%{\e[0m%}'


# }}}

# {{{ Completions

zshrc_load_status 'completion system'

LISTPROMPT=1

# {{{ New advanced completion system

if [[ "$ZSH_VERSION_TYPE" == 'new' ]]; then
  autoload -U compinit
  compinit -C # don't perform security check
else
  print "\nAdvanced completion system not found; ignoring zstyle settings."
  function zstyle { }
  function compdef { }

  # an antiquated, barebones completion system is better than nowt
  which zmodload >&/dev/null && zmodload zsh/compctl
fi

##
## Enable the way cool bells and whistles.
##

# General completion technique
#zstyle ':completion:*' completer _complete _correct _approximate _prefix
zstyle ':completion:*' completer _complete _prefix
zstyle ':completion::prefix-1:*' completer _complete
zstyle ':completion:incremental:*' completer _complete _correct
zstyle ':completion:predict:*' completer _complete

# Completion caching
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# Expand partial paths
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-slashes 'yes'

# Include non-hidden directories in globbed file completions
# for certain commands
#zstyle ':completion::complete:*' \
#  tag-order 'globbed-files directories' all-files 
#zstyle ':completion::complete:*:tar:directories' file-patterns '*~.*(-/)'

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~'

# Separate matches into groups
zstyle ':completion:*:matches' group 'yes'

# Describe each match group.
zstyle ':completion:*:descriptions' format "%B---- %d%b"

# Messages/warnings format
zstyle ':completion:*:messages' format '%B%U---- %d%u%b' 
zstyle ':completion:*:warnings' format '%B%U---- no match for: %d%u%b'
 
# Describe options in full
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'

# }}}
# {{{ Simulate my old dabbrev-expand 3.0.5 patch 

zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# }}}
# {{{ Common usernames

# users=( tom dick harry )

#zstyle ':completion:*' users $users

# }}}
# {{{ Common hostnames

if [[ "$ZSH_VERSION_TYPE" == 'new' ]]; then
  : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}}
else
  # Older versions don't like the above cruft
  _etc_hosts=()
fi

hosts=(
    "$_etc_hosts[@]"

    localhost

    # ftp sites
    sunsite.org.uk
)

zstyle ':completion:*' hosts $hosts

# }}}
# {{{ (user,host) pairs

# All my accounts:
#my_accounts=(
#  {joe,root}@mymachine.com
#  jbloggs@myothermachine.com
#)

# Other people's accounts:
#other_accounts=(
#  {fred,root}@hismachine.com
#  vera@hermachine.com
#)

zstyle ':completion:*:my-accounts' users-hosts $my_accounts
zstyle ':completion:*:other-accounts' users-hosts $other_accounts

# }}}
# {{{ (host, port, user) triples for telnet

#  telnet_users_hosts_ports=(
#    user1@host1:
#    user2@host2:
#    @mail-server:{smtp,pop3}
#    @news-server:nntp
#    @proxy-server:8000
#  )
zstyle ':completion:*:*:telnet:*' users-hosts-ports $telnet_users_hosts_ports

# }}}

# }}}
# {{{ Aliases and functions

zshrc_load_status 'aliases and functions'

# {{{ zrecompile

autoload zrecompile

# }}}
# {{{ which

# reverse unwanted aliasing of `which' by distribution startup
# files (e.g. /etc/profile.d/which*.sh); zsh's which is perfectly
# good as is.

alias which >&/dev/null && unalias which

# }}}
# {{{ run-help

alias run-help >&/dev/null && unalias run-help
autoload run-help

# }}}
# {{{ zcalc

autoload zcalc

# }}}
# {{{ Restarting zsh or bash; reloading .zshrc or functions

bash () {
  NO_SWITCH="yes" command bash "$@"
}

restart () {
  exec $SHELL $SHELL_ARGS "$@"
}

imap () {
    ssh -f -L3500:0:143 bumblebury.com '/bin/sleep 10s' &>/dev/null
    mutt
}

profile () {
  ZSH_PROFILE_RC=1 $SHELL "$@"
}

reload () {
  if [[ "$#*" -eq 0 ]]; then
    . $zdotdir/.zshrc
  else
    local fn
    for fn in "$@"; do
      unfunction $fn
      autoload -U $fn
    done
  fi
}
compdef _functions reload

# }}}
# {{{ ls aliases

if ls -F --color=tty >&/dev/null; then
  alias ls='command ls -F --color=tty'
elif ls -F >&/dev/null; then
  alias ls='command ls -F'
elif ls --color >&/dev/null; then
  alias ls='command ls --color=tty'
fi

# jeez I'm lazy ...
alias l='ls'
alias psg='ps aux | grep '
alias ll='ls -l'
alias la='ls -a'
alias lal='ls -al'
alias lsa='ls -al'
alias lsh='ls -d .*'
alias lsr='ls -R'
alias lt='ls -lt'
alias lrt='ls -lrt'
alias lart='ls -lart'
alias lr='ls -lR'
# damn, missed out lsd :-)
alias sl=ls # often screw this up

# }}}
# {{{ File management

# {{{ Changing/making/removing directory

# blegh
alias ..='cd ..'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias cd/='cd /'
alias C='./configure'
alias CH='./configure --help'

alias 1='cd -'
alias 2='cd +2'
alias 3='cd +3'
alias 4='cd +4'
alias 5='cd +5'
alias 6='cd +6'
alias 7='cd +7'
alias 8='cd +8'
alias 9='cd +9'

cd () {
  if   [[ "x$*" == "x..." ]]; then
    cd ../..
  elif [[ "x$*" == "x...." ]]; then
    cd ../../..
  elif [[ "x$*" == "x....." ]]; then
    cd ../../..
  elif [[ "x$*" == "x......" ]]; then
    cd ../../../..
  else
    builtin cd "$@"
  fi
}

z () {
  builtin cd ~/"$1"
}

alias md='mkdir -p'
alias rd=rmdir

alias d='dirs -v'

po () {
  popd "$@"
  dirs -v
}

# }}}
# {{{ Renaming

autoload zmv

# }}}

# }}}
# {{{ Job/process control

alias j='jobs -l'

# }}}
# {{{ History

alias h=history

# }}}
# {{{ Environment

alias ts=typeset
compdef _vars_eq ts

# }}}
# {{{ Terminal

# {{{ cls := clear

alias cls='clear'

# }}}

# }}}
# {{{ Other users

compdef _users lh

alias f=finger
compdef _finger f

# su changes window title, even if we're not a login shell
su () {
  command su "$@"
  cx
}

# }}}
# {{{ No spelling correction

alias man='nocorrect man'
alias mkdir='nocorrect mkdir'
alias mv='nocorrect mv'
alias rj='nocorrect rj'

# }}}
# {{{ X windows related

# {{{ Changing terminal window/icon titles

if [[ "$TERM" == xterm* ]]; then
  # Could also look at /proc/$PPID/cmdline ...
  which cx >&/dev/null || cx () { }
  cx
fi

# }}}
# {{{ export DISPLAY=:0.0

alias sd='export DISPLAY=:0.0'

# }}}

# }}}
# {{{ Different CVS setups

# Sensible defaults
unset CVS_SERVER
export CVSROOT
export CVS_RSH=ssh

# see scvs function

# }}}
# {{{ Other programs

# {{{ less

alias v=less

# }}}
# {{{ mutt

m () {
  cx mutt
  mutt "$@"
  cxx
}

# }}}
# {{{ editors

# emacs, windowed

# emacs, fast, non-windowed (see also $VISUAL)
fe () {
  QUICK_EMACS=1 emacs -nw "$@"
}

# emacs, slow, non-windowed
se () {
  emacs -nw "$@"
}

alias pico='/usr/bin/pico -z'

# }}}
# {{{ remote logins

ssh () {
  command /usr/bin/ssh "$@"
  cx
}

# Best to run this from .zshrc.local
#dsa >&/dev/null

alias sa=ssh-add

# }}}
# {{{ ftp

if which lftp >&/dev/null; then
  alias ftp=lftp
elif which ncftp >&/dev/null; then
  alias ftp=ncftp
fi

# }}}
# {{{ watching log files

alias tf='less +F'

# }}}
# {{{ arch

if which larch >&/dev/null; then
  alias a=larch
  compdef _larch a
fi

# }}}

# }}}

# {{{ Global aliases

# WARNING: global aliases are evil.  Use with caution.

alias -g L='|& less'
alias -g LS='| less -S'
alias -g G='| grep -i'
alias -g GC='| grep'
alias -g KP='| xargs kill -9'
alias -g XKP="| awk '{print \$2}' | xargs kill -9"
alias -g EL='|& less'
alias -g ELS='|& less -S'
alias -g H='| head -20'
alias -g T='| tail -20'

# }}}
# {{{ Sorting / counting

alias -g C='| wc -l'

alias -g S='| sort'
alias -g US='| sort -u'
alias -g NS='| sort -n'
alias -g RNS='| sort -nr'

# }}}
# {{{ common filenames

alias -g DN=/dev/null
alias -g OP=./output

# }}}

# }}}

# }}}
# {{{ Key bindings 

zshrc_load_status 'key bindings'

bindkey -e  ## emacs key bindings

bindkey -s "^Xe" 'emacs &\n' ## start

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^[^[[C' emacs-forward-word
bindkey '^[^[[D' emacs-backward-word

bindkey -s '^X^Z' '%-^M'
bindkey '^[e' expand-cmd-path
bindkey '^[^I' reverse-menu-complete
bindkey '^X^N' accept-and-infer-next-history
bindkey '^W' kill-region
bindkey '^I' complete-word
# Fix weird sequence that rxvt produces
bindkey -s '^[[Z' '\t'

# }}}
# {{{ Miscellaneous

zshrc_load_status 'miscellaneous'

# }}}
# {{{ ls colours

if which dircolors >&/dev/null && [[ -e "${zdotdir}/.dircolors" ]]; then
  # show directories in yellow
  eval `dircolors -b $zdotdir/.dircolors`
fi

if [[ $ZSH_VERSION > 3.1.5 ]]; then
  zmodload -i zsh/complist

  zstyle ':completion:*' list-colors ''

  zstyle ':completion:*:*:kill:*:processes' list-colors \
    '=(#b) #([0-9]#)*=0=01;31'

  # completion colours
  zstyle ':completion:*' list-colors "$LS_COLORS"
fi  

# }}}

# }}}

# {{{ Specific to xterms

if [[ "${TERM}" == xterm* ]]; then
  unset TMOUT

  precmd () {
	print -Pn  "\033]0;%n@%m %~\007"
	#print -Pn "\033]0;%n@%m%#  %~ %l  %w :: %T\a" ## or use this
  }

  preexec () {
	print -Pn "\033]0;%n@%m <$1> %~\007"
	#print -Pn "\033]0;%n@%m%#  <$1>  %~ %l  %w :: %T\a" ## or use this
  }

fi

# }}}
# {{{ Specific to hosts

if [[ -r ~/.zshrc.local ]]; then
  zshrc_load_status '.zshrc.local'
  . ~/.zshrc.local
fi

if [[ -r ~/.zshrc.${HOST%%.*} ]]; then
  zshrc_load_status ".zshrc.${HOST%%.*}"
  . ~/.zshrc.${HOST%%.*}
fi

# }}}

# {{{ Clear up after status display

if [[ $TERM == tgtelnet ]]; then
  echo
else
  echo -n "\r"
fi

# }}}
# {{{ Profile report

if [[ -n "$ZSH_PROFILE_RC" ]]; then
  zprof >! ~/zshrc.zprof
  exit
fi

# }}}

# {{{ Search for history loosing bug

which _check_hist_size >&/dev/null &&_check_hist_size

# }}}

path=(/opt/local/bin /opt/local/sbin /usr/local/bin $path)

for optbinpath in `echo /thieso/software/*/current/bin`; do
        path=($optbinpath $path)
done
#
#for optmanpath in `echo /opt/*/man`; do
#        MANPATH="$optmanpath $MANPATH"
#done

#export TMPDIR=/tmp
#path=($ORACLE_HOME/bin $path)
#. /usr/share/doc/darcs/examples/zsh_completion_new

export TERM=rxvt
