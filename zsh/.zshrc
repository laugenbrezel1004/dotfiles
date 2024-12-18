neofetch
# Starship prompt

# If no prompt available
# PROMPT=$'\n%F{%(#.blue.green)} ╭─(%B%F{%(#.red.blue)}%n@%m%b%F{%(#.blue.green)})-[%B%F{reset}%(6~.%-1~/…/%4~.%5~)%b%F{%(#.blue.green)}]\n ╰─%B%(#.%F{red}#.%F{blue}☣)%b%F{reset} '
#  RPROMPT=$'%(?.. %? %F{red}%Bx%b%F{reset})%(1j. %j %F{yellow}%Bbg %b%F{reset}.)'


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Loads ~/.zcompdump only once per day thus reducing loading time
autoload -Uz compinit

if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
	compinit -d $ZSH_COMPDUMP
else
	compinit -C
fi

# Uncomment the following line to use hyphen-insensitive completion.
HYPHEN_INSENSITIVE="true"

# aliases
if [ -f ~/.dotfiles/zsh/.aliases ]; then
    source ~/.dotfiles/zsh/.aliases
fi
if [ -f ~/.dotfiles/zsh/bindkey ]; then
    source ~/.dotfiles/zsh/bindkey
fi
if [ -f ~/.dotfiles/zsh/dependencies ]; then
     source ~/.dotfiles/zsh/dependencies
fi
if [ -f ~/.dotfiles/zsh/eval ]; then
     source ~/.dotfiles/zsh/eval
fi
if [ -f ~/.dotfiles/zsh/export ]; then
    source ~/.dotfiles/zsh/export
fi
if [ -f ~/.dotfiles/zsh/setopt ]; then
    source ~/.dotfiles/zsh/setopt
fi
if [ -f ~/.dotfiles/zsh/unsetopt ]; then
    source ~/.dotfiles/zsh/unsetopt
fi
if [ -f ~/.dotfiles/zsh/zinit ]; then
    source ~/.dotfiles/zsh/zinit
fi
if [ -f ~/.dotfiles/zsh/zstyle ]; then
    source ~/.dotfiles/zsh/zstyle
fi

# if [  which thefuck -eq 0 ]; then
#   eval $(thefuck --alias)
# fi
#
if  which thefuck &> /dev/null ; then
  eval $(thefuck --alias)
fi

eval "$(starship init zsh)"
