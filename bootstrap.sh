#!/usr/bin/env bash
#
# bootstrap installs things.

DOTFILES_ROOT="`pwd`"

set -e

echo ''

info () {
  printf "  [ \033[00;34m..\033[0m ] $1"
}

user () {
  printf "\r  [ \033[0;33m?\033[0m ] $1 "
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

link_files () {
  ln -s $1 $2
  success "linked $1 to $2"
}

install_dotfiles () {
  info 'Installing dotfiles'

  overwrite_all=false
  backup_all=false
  skip_all=false

  for source in `find $DOTFILES_ROOT -maxdepth 2 -name \*.symlink`
  do
    dest="$HOME/.`basename \"${source%.*}\"`"

    if [ -f $dest ] || [ -d $dest ]
    then

      overwrite=false
      backup=false
      skip=false

      if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
      then
        user "File already exists: `basename $source`, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac
      fi

      if [ "$overwrite" == "true" ] || [ "$overwrite_all" == "true" ]
      then
        rm -rf $dest
        success "removed $dest"
      fi

      if [ "$backup" == "true" ] || [ "$backup_all" == "true" ]
      then
        mv $dest $dest\.backup
        success "moved $dest to $dest.backup"
      fi

      if [ "$skip" == "false" ] && [ "$skip_all" == "false" ]
      then
        link_files $source $dest
      else
        success "skipped $source"
      fi

    else
      link_files $source $dest
    fi

  done
}

run_installers () {
  info 'Running installers'
  echo ''
  find . -name install.sh | while read installer ; do sh -c "${installer}" ; done
  echo ''
}

install_formulas () {
  info 'Updating Homebrew: '
  brew update
  info 'Checking Homebrew is healthy: '

  if ! brew doctor; then
    fail "There's a problem with Homebrew. Fix it and confirm with 'brew doctor' before continuing"
  fi

  echo ''
  for file in `find $DOTFILES_ROOT -maxdepth 2 -name install.homebrew`
  do
    for formula in `cat $file`
    do
      install_formula $formula
    done
  done
}

install_formula () {
  formula=$1
  if brew ls --versions $formula | grep -q $formula; then
    success "$1 is already installed"
  else
    if brew install $formula
    then
      success "Installed $formula"
    else
      fail "Failed to install $formula"
    fi
  fi
}

info "Bootstrapping dotfiles"

install_dotfiles
run_installers
install_formulas

success 'Bootstrap complete!'
