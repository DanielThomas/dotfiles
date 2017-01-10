#!/usr/bin/env bash
#
# bootstrap dotfiles

source scripts/common.sh

link_files () {
  case "$1" in
    link )
      link_file $2 $3
      ;;
    copy )
      copy_file $2 $3
      ;;
    git )
      git_clone $2 $3
      ;;
    * )
      fail "Unknown link type: $1"
      ;;
  esac
}

link_file () {
  ln -s $1 $2
  success "linked $1 to $2"
}

copy_file () {
  cp $1 $2
  success "copied $1 to $2"
}

open_file () {
  run "opening $1" "open $1"
  success "opened $1"
}

git_clone () {
  repo=$(head -n 1 $1)
  dest=$2
  if ! git clone --quiet $repo $dest; then
    fail "clone for $repo failed"
  fi

  success "cloned $repo to `basename $dest`"

  dir=$(dirname $1)
  base=$(basename ${1%.*})
  for patch in $(dotfiles_find "$base\*.gitpatch"); do
    pushd $dest >> /dev/null
    if ! git am --quiet $patch; then
      fail "apply patch failed"
    fi

    success "applied $patch"
    popd >> /dev/null
  done
}

install_dotfiles () {
  overwrite_all=false
  backup_all=false
  skip_all=false

  # symlinks
  for file_source in $(dotfiles_find \*.symlink); do
    file_dest="$HOME/.`basename \"${file_source%.*}\"`"
    install_file link $file_source $file_dest
  done

  # git repositories
  for file_source in $(dotfiles_find \*.gitrepo); do
    file_dest="$HOME/.`basename \"${file_source%.*}\"`"
    install_file git $file_source $file_dest
  done

  # preferences
  for file_source in $(dotfiles_find \*.plist); do
    file_dest="$HOME/Library/Preferences/`basename $file_source`"
    install_file copy $file_source $file_dest
  done

  # fonts
  for file_source in $(dotfiles_find \*.otf -or -name \*.ttf -or -name \*.ttc); do
    file_dest="$HOME/Library/Fonts/$(basename $file_source)"
    install_file copy $file_source $file_dest
  done
}

install_file () {
  file_type=$1
  file_source=$2
  file_dest=$3
  if [ -f $file_dest ] || [ -d $file_dest ]; then
    overwrite=false
    backup=false
    skip=false

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]; then
      user "File already exists: `basename $file_dest`, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
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

    if [ "$overwrite" == "true" ] || [ "$overwrite_all" == "true" ]; then
      rm -rf $file_dest
      success "removed $file_dest"
    fi

    if [ "$backup" == "true" ] || [ "$backup_all" == "true" ]; then
      mv $file_dest $file_dest\.backup
      success "moved $file_dest to $file_dest.backup"
    fi

    if [ "$skip" == "false" ] && [ "$skip_all" == "false" ]; then
      link_files $file_type $file_source $file_dest
    else
      success "skipped $file_source"
    fi

  else
    link_files $file_type $file_source $file_dest
  fi
}

run_installers () {
  info 'running installers'
  find -L . -name install.sh | while read installer ; do run "running ${installer}" "${installer}" ; done

  info 'opening files'
  OLD_IFS=$IFS
  IFS=''
  for file_source in $(dotfiles_find install.open); do
    for file in `cat $file_source`; do
      expanded_file=$(eval echo $file)
      open_file $expanded_file
    done
  done
  IFS=$OLD_IFS
}

install_formulas () {
  # assume that the installer did it's job, and use the default path for brew if it's not there already
  if ! test $(which brew); then
    source $DOTFILES_ROOT/brew/path.zsh
  fi

  for file in `dotfiles_find install.homebrew-cask`; do
    for formula in `cat $file`; do
      brew_install $formula cask
    done
  done

  for file in `dotfiles_find install.homebrew`; do
    for formula in `cat $file`; do
      brew_install $formula
    done
  done
}

brew_install () {
  formula=$1
  if ! brew $2 ls --versions $formula 2> /dev/null | grep -q $formula; then
    if brew $2 install $formula > /dev/null 2>&1; then
      success "installed $formula"
    else
      fail "failed to install $formula"
    fi
  fi
}

create_localrc () {
  LOCALRC=$HOME/.localrc
  if [ ! -f "$LOCALRC" ]; then
    echo "DEFAULT_USER=$USER" > $LOCALRC
    success "created $LOCALRC"
  fi
}

pull_repos () {
  for file in $(dotfiles_find \*.gitrepo); do
    repo="$HOME/.`basename \"${file%.*}\"`"
    pushd $repo > /dev/null
    if ! git pull --rebase --quiet origin master; then
      fail "could not update $repo"
    fi
    success "updated $repo"
    popd >> /dev/null
  done
}

if [ "$1" = "update" ]; then
  info 'updating dotfiles'
  pull_repos

  run_installers
  run 'updating homebrew' 'brew update'
  run 'upgrading homebrew' 'brew upgrade'
  install_formulas
  run 'cleaning up homebrew' 'brew cleanup'
else
  info 'installing dotfiles'
  install_dotfiles
  run_installers
  install_formulas
  create_localrc
fi

info 'complete!'
echo ''
