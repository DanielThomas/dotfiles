if [[ "Linux" == "$(uname)" ]]; then
	if [[ -z "$SSH_AGENT_PID" ]]; then
		if ! ps -p $SSH_AGENT_PID > /dev/null; then
			eval "$(ssh-agent -s)" > /dev/null
		fi
	else
		eval "$(ssh-agent -s)" > /dev/null
	fi
fi
