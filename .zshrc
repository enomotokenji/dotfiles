
# 補完を有効化
autoload -Uz compinit
compinit

# 大文字小文字を無視
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# keybindをvim風に
bindkey -v

setopt AUTO_CD

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	#alias dir='dir --color=auto'
	#alias vdir='vdir --color=auto'

	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
else
	export LSCOLORS=exfxcxdxbxegedabagacad
	alias ls='ls -FG'
fi

# promptにgitのbranchを表示するため
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b'
#zstyle ':vcs_info:*' formats '%b'

setopt PROMPT_SUBST
PROMPT="%F{blue}%n%f:%F{yellow}%~%f:%F{magenta}${vcs_info_msg_0_}%f\$ "

# alias
alias tma='tmux a -t'
alias g='git branch; git status'
