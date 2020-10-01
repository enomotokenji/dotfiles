# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

git_branch() {
  echo $(git branch --no-color 2>/dev/null | sed -ne "s/^\* \(.*\)$/\1/p")
}

PS1='-- \n\[\033[36m\]\u\[\033[0m\]\[\033[33m\]@\h\[\033[0m\]:\[\033[32m\]\w\[\033[0m\]:\[\033[35m\]$(git_branch)\[\033[0m\]\$ '

# User specific aliases and functions

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

alias tma='tmux a -t'
#alias blender='/Applications/Blender/blender.app/Contents/MacOS/blender --background --python'
alias g='git branch; git status'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/enomotokenji/google-cloud-sdk/path.bash.inc' ]; then . '/Users/enomotokenji/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/enomotokenji/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/enomotokenji/google-cloud-sdk/completion.bash.inc'; fi
