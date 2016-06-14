# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
if [[ -f ~/.dir_colors ]] ; then
	eval $(dircolors -b ~/.dir_colors)
elif [[ -f /etc/DIR_COLORS ]] ; then
	eval $(dircolors -b /etc/DIR_COLORS)
fi

autoload -U compinit
compinit

autoload -U select-word-style
select-word-style bash

PS1="%B%(!.%F{red}%m.%F{green}%n@%m) %F{blue}%1~ %F{blue}%(!.#.$)%f%b "
PS2="%B %_ %F{blue}>%f%b "


#setopt correct
#setopt correct_all
#setopt complete_aliases
setopt complete_in_word
setopt auto_cd
setopt extended_glob
setopt long_list_jobs
#setopt nonomatch
setopt notify
#setopt menu_complete
setopt nohup
#setopt no_sh_word_split
setopt flow_control
setopt append_history hist_ignore_dups inc_append_history hist_expire_dups_first hist_reduce_blanks
#setopt share_history
setopt octal_zeroes
setopt no_list_ambiguous
setopt rmstarsilent
setopt auto_param_slash
setopt ksh_arrays


zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*:descriptions' format '%U%B%F{yellow}%d%f%b%u'
zstyle ':completion:*:warnings' format ' %U%B%F{red}No%u matches!%f%b'
#zstyle ':completion:*:corrections' format '%U%B%F{green}%d%f%b%f'
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:processes' command 'ps -eo pid,tty,cmd'
zstyle ':completion:*:processes-names' command 'ps -eo cmd='
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle -e ':completion:*:aliases' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==04}")'
zstyle -e ':completion:*:builtins' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==04}")'
zstyle -e ':completion:*:commands' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==04}")'
zstyle -e ':completion:*:parameters' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)*==04}")'
#
zstyle ':completion:*:options' list-colors '=^(-- *)=01;33'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=33=01;31'
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*:complete:*' use-cache 1
zstyle ':completion:*' cache-path /tmp/.zshcache
#zstyle ':completion:*' completer _complete _match _approximate
#zstyle ':completion:*:match:*' original only
#zstyle ':completion:*:approximate:*' max-errors 1 numeric

zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//,/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'


export HISTSIZE=1000
export HISTFILE="$HOME/.bash_history" # Share history with bash
export SAVEHIST=$HISTSIZE

export EDITOR=vim

bindkey -e

typeset -A key
key[Up]="^[[A"
key[Down]="^[[B"
key[Left]="^[[D"
key[Right]="^[[C"
key[Delete]="^[[3~"
key[Insert]="^[[2~"
key[Home]="^[[H"
key[End]="^[[F"
key[PageUp]="^[[5~"
key[PageDown]="^[[6~"
key[CtrlRight]="^[[1;5C"
key[CtrlLeft]="^[[1;5D"
key[AltRight]="^[[1;3C"
key[AltLeft]="^[[1;3D"
key[HomeTmux]="^[[1~"
key[EndTmux]="^[[4~"
key[CtrlRightTmux]="^[OC"
key[CtrlLeftTmux]="^[OD"
key[AltBackspace]="^[^?"
key[ShiftTab]="^[[Z"

bindkey "${key[Up]}"            up-line-or-history
bindkey "${key[Down]}"          down-line-or-history
bindkey "${key[Left]}"          backward-char
bindkey "${key[Right]}"         forward-char
bindkey "${key[Delete]}"        delete-char
bindkey "${key[Insert]}"        overwrite-mode
bindkey "${key[Home]}"          beginning-of-line
bindkey "${key[End]}"           end-of-line
bindkey "${key[PageUp]}"        history-beginning-search-backward
bindkey "${key[PageDown]}"      history-beginning-search-forward
bindkey "${key[CtrlRight]}"     forward-word
bindkey "${key[CtrlLeft]}"      backward-word
bindkey "${key[AltRight]}"      forward-word
bindkey "${key[AltLeft]}"       backward-word

bindkey "${key[CtrlRightTmux]}" forward-word
bindkey "${key[CtrlLeftTmux]}"  backward-word
bindkey "${key[HomeTmux]}"      beginning-of-line
bindkey "${key[EndTmux]}"       end-of-line

bindkey "${key[AltBackspace]}"  backward-kill-word

zmodload zsh/complist
bindkey -M menuselect "${key[ShiftTab]}" reverse-menu-complete

bindkey -M menuselect "${key[Home]}" emacs-editing-mode
bindkey -M menuselect "${key[End]}" emacs-editing-mode
bindkey -M menuselect "${key[HomeTmux]}" emacs-editing-mode
bindkey -M menuselect "${key[EndTmux]}" emacs-editing-mode


alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias l='ls -lAh'
alias duh='du -h --max-depth=1'
alias dmesg='dmesg --color'
alias md=mkdir
alias -- -='cd -'
alias :e='vim'
alias :q='exit'
alias x='sudo -i'
alias cal='cal -m'
alias lspci=/usr/sbin/lspci
alias prime='DRI_PRIME=1'
alias update='emerge -DuNav --with-bdeps=y world'
alias unmerge='emerge --unmerge'
alias pbg='ping google.bg'
alias p88='ping 8.8.8.8'
alias tmux='tmux -2'
