# .zshrc

# Determine OS
uname=$(/usr/bin/uname -s)
export OSNAME=${uname%_*}

# Set default permissions to 700.
umask 077

typeset -U path
typeset -U fpath

# set PATH so that /usr/sbin is included under Cygwin
if [[ $OSNAME == "CYGWIN" ]]; then
	path=(/usr/sbin $path)
fi

# set environment variables for Java
if [[ $OSNAME == "CYGWIN" ]]; then
	export JAVA_HOME="/c/Program Files/Java/jdk1.7.0_17"
	path=($JAVA_HOME/bin $path)
fi

# set PATH so it includes TexLive's bin
if [[ $OSNAME == "Darwin" ]]; then
	path=(/Users/Shared/texlive/2012/bin/x86_64-darwin $path)
elif [[ $OSNAME == "Linux" ]]; then
	path=(/home/shared/texlive/2012/bin/x86_64-linux $path)
fi

# set PATH so it includes user's private bin
path=(~/bin $path)

# set PATH so it includes executable Python scripts
path=(/usr/local/share/python $path)

# set PATH so that /usr/local/bin is preferred
path=(/usr/local/bin $path)

# Amend fpath for better completion
fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)

# Set default editor
export EDITOR=nano

# History stuff
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory incappendhistory histignorealldups

# Aliases
alias ls='ls -F'
alias ll='ls -Alh'
alias nano='nano --nowrap'
alias unison='unison -ui text'
if [[ $OSNAME == "CYGWIN" ]]; then
	alias open=cygstart
elif [[ $OSNAME == "Linux" ]]; then
	alias open='xdg-open $@ 2>/dev/null'
fi
alias o=open

# Completion
autoload -Uz compinit
compinit
# Use case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Prompt
autoload colors && colors
PROMPT="%{$fg_bold[blue]%}%~\$%{$reset_color%} "
RPROMPT="%{$fg_bold[blue]%}%n@%m%{$reset_color%}"

# Miscellaneous options
setopt nobeep correct

# Avoid copying of extended attributes on Darwin
if [[ $OSNAME == "Darwin" ]]; then
	export COPYFILE_DISABLE=true
fi

# Set the default locale
export LANG=en_GB.UTF-8

# SSH agent configuration for Cygwin
if [[ $OSNAME == "CYGWIN" ]]; then
	if [ -f ~/.ssh-agent ]; then
		. ~/.ssh-agent > /dev/null
	fi
	if [[ -n $SSH_PAGEANT_PID ]] && kill -0 $SSH_PAGEANT_PID 2>/dev/null; then true; else
		ssh-pageant | sed 's/^echo/#echo/' > ~/.ssh-agent
		. ~/.ssh-agent > /dev/null
	fi
fi
