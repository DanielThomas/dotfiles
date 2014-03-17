#!/bin/sh
if ! test $(which brew); then
  echo "  Installing Homebrew..."
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)" > /tmp/homebrew-install.log
fi
