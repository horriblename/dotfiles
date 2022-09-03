# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ ! -f "$HOME/.profile" ]] || source "$HOME/.profile"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -z $EDITOR ]; then
	if command -v nvim &> /dev/null; then
		export EDITOR='nvim'
	elif command -v vim &> /dev/null; then
		export EDITOR='vim'
	fi
fi

alias q=exit
alias l="lsd"
alias ll="lsd -l"
alias lf="~/.config/lf/lfrun"
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias xtprc="~/scripts/disable-touchpad-right-click.sh"
#alias conda-on="/mnt/ext/lapps/anaconda3/bin/conda activate"
alias pf=paleofetch
alias n="$EDITOR"
alias nn="$EDITOR ./"
alias cd='pushd -q'
alias dirs='dirs -p'
alias nl="lvim"
alias nv="glvim"
alias lg="lazygit"
alias cc="calcurse"
alias o=xdg-open
alias path='echo "$PATH" | sed -e "s/:/\n/g" -'
alias swayrun='swaymsg scratchpad show &&'

# package management
alias inst='paru -S'
alias syu='paru -Syu && ~/.local/bin/pacmanfile sync'
alias ss='paru -Ss'
alias pacf='nvim -c "cd ~/.config/pacmanfile" + ~/.config/pacmanfile/pacmanfile.txt && ~/.local/bin/pacmanfile sync'

# too lazy to deal with theming
export GTK_THEME=Breeze # Adwaita:dark

# Enable colors and change prompt:
autoload -U colors && colors

setopt PUSHD_SILENT PUSHD_IGNORE_DUPS

# History in cache directory:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.cache/zsh/history
setopt histignoredups

autoload -U compinit && compinit -u
zstyle ':completion:*' menu select
# Auto complete with case insenstivity
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Enable searching through history
bindkey '^R' history-incremental-pattern-search-backward

bindkey -M vicmd 'H' vi-beginning-of-line
bindkey -M vicmd 'L' vi-end-of-line
bindkey -M vicmd 'Y' vi-yank-eol

# Edit line in vim buffer ctrl-v
autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line
# Enter vim buffer from normal mode
autoload -U edit-command-line && zle -N edit-command-line && bindkey -M vicmd "^v" edit-command-line

# Use vim keys in tab complete menu:
bindkey -M menuselect '^h' vi-backward-char
bindkey -M menuselect '^j' vi-down-line-or-history
bindkey -M menuselect '^k' vi-up-line-or-history
bindkey -M menuselect '^l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char
# Fix backspace bug when switching modes
bindkey "^?" backward-delete-char
# Browse history
bindkey '^p' up-history
bindkey '^n' down-history

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

# ci", ci', ci`, di", etc
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
  for c in {a,i}{\',\",\`}; do
    bindkey -M $m $c select-quoted
  done
done

# ci{, ci(, ci<, di{, etc
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $m $c select-bracketed
  done
done

zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init

echo -ne '\e[5 q' # Use beam shape cursor on startup.
precmd() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# Control bindings for programs
#bindkey -s "^g" "lc\n"
bindkey -s "^g" "lazygit\n"
bindkey "^l" clear-screen
lfcd (){
	tmp="$(mktemp)"
	lf -last-dir-path="$tmp" "$@"
	if [ -f "$tmp" ]; then
		dir="$(cat "$tmp")"
		rm -f "$tmp"
		[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && pushd "$dir"
	fi
}
bindkey -s "^o" "lfcd\n"

# Source configs
#for f in ~/.config/shellconfig/*; do source "$f"; done
#source /home/brodie/.config/broot/launcher/bash/br

# Load zsh-syntax-highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
# Load zsh-autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh 2>/dev/null
# Search repos for programs that can't be found
#source /usr/share/doc/pkgfile/command-not-found.zsh 2>/dev/null

_ZL_CD=pushd
eval "$(lua ~/scripts/z.lua --init zsh enhanced)"

# Manually set title
_title_precmd(){ echo -ne '\e]0;zsh\007' }
_title_preexec() { echo -ne "\e]0;${1%% *}\007" }

typeset -ga precmd_functions
[ -n "${precmd_functions[(r)_title_precmd]}" ] || {
	precmd_functions[$(($#precmd_functions+1))]=_title_precmd
}

typeset -ga preexec_functions
[ -n "${preexec_functions[(r)_title_preexec]}" ] || {
	preexec_functions[$(($#preexec_functions+1))]=_title_preexec
}

if [ ! -z ${NVIM:+x} -a -z "x" ]; then
	_nvimmux_precmd() {
		#nvim --server "$NVIM" --remote-expr "mux#setTitle('$$',&shell)" > /dev/null
	}

	typeset -ga precmd_functions
	[ -n "${precmd_functions[(r)_nvimmux_precmd]}" ] || {
		precmd_functions[$(($#precmd_functions+1))]=_nvimmux_precmd
	}

	_nvimmux_preexec() {
		#cmd=$(echo $1 | sed "s/'/\\'/g")
		cmd="$1"
		nvim --server "$NVIM" --remote-expr "mux#setTitle('$$','$cmd')" | cat
	}

	typeset -ga preexec_functions
	[ -n "${preexec_functions[(r)_nvimmux_preexec]}" ] || {
		preexec_functions[$(($#preexec_functions+1))]=_nvimmux_preexec
	}
fi

# Power level 10k prompt
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/mnt/ext/lapps/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/mnt/ext/lapps/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/mnt/ext/lapps/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/mnt/ext/lapps/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [[ $TTY =~ "/dev/tty" ]]; then
   [[ ! -f "$ZDOTDIR/.p10k-tty.zsh" ]] || source "$ZDOTDIR/.p10k-tty.zsh"
else
	# some terminals still use ^h as backspace (modern ones use ^h for ^Backspace)
	# the mose obvious example is tty
	bindkey "^h" backward-delete-word
   [[ ! -f "$ZDOTDIR/.p10k.zsh" ]] || source "$ZDOTDIR/.p10k.zsh"
fi
