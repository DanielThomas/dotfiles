#!/usr/bin/env bash
#
# common script functions and variables

DOTFILES_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )"

set -e

echo ''

info () {
  printf "  [ \033[00;34m..\033[0m ] %s\n" "$1"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] %s " "$1"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] %s\n" "$1"
}

fail () {
  printf "\r\033[2K  [ \033[0;31m!!\033[0m ] %s\n" "$1"
  echo ''
  exit
}

run() {
  set +e
  info "$1"
  output=$($2 2>&1)
  if [ $? -ne 0 ]; then
    fail "failed to run $1\n$output"
    exit
  fi
  set -e
}

dotfiles_find() {
    find -L "$DOTFILES_ROOT" -maxdepth 3 -name "$1"
}
