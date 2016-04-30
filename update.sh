#!/usr/bin/env bash
#
# update bootstrapped resources

source scripts/common.sh

info "upgrading dotfiles, grab some coffee"

for file in `find $DOTFILES_ROOT -maxdepth 2 -name \*.gitrepo`; do
  repo="$HOME/.`basename \"${file%.*}\"`"
  pushd $repo > /dev/null
  if ! git pull --rebase --quiet origin master; then
    fail "could not update $repo"
  fi
  success "updated $repo"
  popd >> /dev/null
done

run 'updating homebrew' 'brew update'
run 'upgrading homebrew' 'brew upgrade'
run 'cleaning up homebrew' 'brew cleanup'

info "update complete!"
