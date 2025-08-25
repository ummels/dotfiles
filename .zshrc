# .zshrc

# Determine OS
uname=$(uname -s)
export OSNAME=${uname%_*}

typeset -U path
typeset -U fpath

# set PATH so it includes Homebrew's bin
if [[ $OSNAME == "Darwin" ]]; then
	path=(/opt/homebrew/sbin /opt/homebrew/bin /opt/homebrew/opt/ruby/bin $path)
fi

# set PATH so it includes user's private bin
path=(~/bin $path)

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

# Append indictor to ls entries
alias ls='ls -F'
#alias ls='ls -F --color=auto'

# Enable color support of grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# More aliases
alias ll='ls -Alh'
alias nano='nano --nowrap'
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

# Automatically quote globs in URL and remote references
__remote_commands=(scp rsync)
autoload -U url-quote-magic
zle -N self-insert url-quote-magic
zstyle -e :urlglobber url-other-schema '[[ $__remote_commands[(i)$words[1]] -le ${#__remote_commands} ]] && reply=("*") || reply=(http https ftp)'

# Miscellaneous options
setopt nobeep correct

# Avoid copying of extended attributes on Darwin
if [[ $OSNAME == "Darwin" ]]; then
	export COPYFILE_DISABLE=true
fi

# Set the default locale
export LANG=en_GB.UTF-8

# Add ANDROID_HOME under Darwin

if [[ $OSNAME == "Darwin" ]]; then
	export ANDROID_HOME=/usr/local/opt/android-sdk
fi

# Secret stuff

if [ -r $HOME/.zshrc.secret ]; then
	source $HOME/.zshrc.secret
fi
