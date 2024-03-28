if [[ "Linux" == "$(uname)" ]]; then
	if ! ps -p $SSH_AGENT_PID > /dev/null; then
		eval "$(ssh-agent -s)" > /dev/null
	fi
fi
