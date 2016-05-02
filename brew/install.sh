#!/bin/sh
if ! test $(which brew); then
  echo "  Installing Homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" > /tmp/homebrew-install.log
  brew tap caskroom/versions
  brew tap homebrew/versions
fi
