export EDITOR="st -w"
export HOMEBREW_NO_ENV_HINTS=1

if [[ "Darwin" != "$(uname)" ]]; then
	export BROWSER=opener-browser
fi
