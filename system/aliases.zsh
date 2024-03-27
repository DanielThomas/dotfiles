# overrides for ls
if ! which dircolors > /dev/null; then
	alias ls="gls -F --color=auto"
fi
alias l="ls -lAh --color=auto"
alias ll="ls -l --color=auto"
alias la="ls -A --color=auto"

# allow for common cd typo
alias cd..="cd .."

alias tf="tail -f"

alias fl="fleet"
