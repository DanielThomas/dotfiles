if [ -z "$CODER_WORKSPACE_NAME" ]; then
	export JENV_HOME="$HOME/.jenv"
	export PATH=$JENV_HOME/bin:$PATH

	eval "$(jenv init - --no-rehash)"
	(jenv rehash &) 2> /dev/null
	jenv enable-plugin export >  /dev/null
fi
