# Colors/GNU ls
if which dircolors > /dev/null; then
	eval `dircolors $HOME/.dircolors-solarized/dircolors.256dark`
else	
	eval `gdircolors $HOME/.dircolors-solarized/dircolors.256dark`
fi

# Grep highlight color
export GREP_COLOR='1;31'
