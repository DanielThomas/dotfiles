if [[ "Linux" == "$(uname)" ]]; then
	eval "$(ssh-agent -s)"
fi
