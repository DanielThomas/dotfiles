#!/usr/bin/env sh

if [[ "Darwin" == "$(uname)" ]]; then
	brew services start opener
fi
