# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
if [[ -f ~/.dir_colors ]] ; then
	eval $(dircolors -b ~/.dir_colors)
elif [[ -f /etc/DIR_COLORS ]] ; then
	eval $(dircolors -b /etc/DIR_COLORS)
fi

autoload -U compinit
compinit

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


zstyle ':completion:*' menu select
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
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path /tmp/.zshcache
#zstyle ':completion:*' completer _complete _match _approximate
#zstyle ':completion:*:match:*' original only
#zstyle ':completion:*:approximate:*' max-errors 1 numeric

zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//,/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'


export HISTSIZE=500
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
key[Home]="^[OH"
key[End]="^[OF"
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

bindkey -M emacs "${key[Up]}"        up-line-or-history
bindkey -M emacs "${key[Down]}"      down-line-or-history
bindkey -M emacs "${key[Left]}"      backward-char
bindkey -M emacs "${key[Right]}"     forward-char
bindkey -M emacs "${key[Delete]}"    delete-char
bindkey -M emacs "${key[Insert]}"    overwrite-mode
bindkey -M emacs "${key[Home]}"      beginning-of-line
bindkey -M emacs "${key[End]}"       end-of-line
bindkey -M emacs "${key[PageUp]}"    history-beginning-search-backward
bindkey -M emacs "${key[PageDown]}"  history-beginning-search-forward
bindkey -M emacs "${key[CtrlRight]}" forward-word
bindkey -M emacs "${key[CtrlLeft]}"  backward-word
bindkey -M emacs "${key[AltRight]}"  forward-word
bindkey -M emacs "${key[AltLeft]}"   backward-word
#
bindkey -M emacs "${key[CtrlRightTmux]}" forward-word
bindkey -M emacs "${key[CtrlLeftTmux]}"  backward-word
bindkey -M emacs "${key[HomeTmux]}"      beginning-of-line
bindkey -M emacs "${key[EndTmux]}"       end-of-line

zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete

function zle-line-init {
	exc=$?
	if (($exc == 0)); then
		RPS1=%B%F{yellow}^_^\ %F{green}OK%b
	elif (($exc == 1)); then
		RPS1=%B%F{red}error\ %F{magenta}1%b
	elif (($exc == 2)); then
		RPS1=%B%F{red}error\ %F{magenta}2%b
	elif (($exc == 124)); then
		RPS1=%B%F{yellow}timeouted%b%f
	elif (($exc == 126)); then
		RPS1=%B%F{yellow}denied%b%f
	elif (($exc == 127)); then
		RPS1=%B%F{yellow}not\ found%b%f
	elif (($exc > 127 && $exc < 162)); then
		RPS1=%B%F{red}SIG$signals[$((exc-127))]%f%b
	else RPS1=%B%F{red}exit\ %F{magenta}%?%b%f
	fi
	zle reset-prompt
}
zle -N zle-line-init


alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias egrep='egrep --colour=auto'
alias fgrep='fgrep --colour=auto'
alias l='ls -lAh'
alias dmesg='dmesg --color'
alias md=mkdir
alias -- -='cd -'
alias :e=vim
alias x='sudo -i'
alias cal='cal -m'
alias lspci=/usr/sbin/lspci
alias prime='DRI_PRIME=1'
alias update='emerge -DuNav --with-bdeps=y world'
alias pbg='ping google.bg'
alias p88='ping 8.8.8.8'
alias tmux='tmux -2'
