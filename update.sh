#!/usr/bin/env bash
#
# update bootstrapped resources

source scripts/common.sh

info "upgrading dotfiles"

for file in `find $DOTFILES_ROOT -maxdepth 2 -name \*.gitrepo`; do
  repo="$HOME/.`basename \"${file%.*}\"`"
  pushd $repo > /dev/null
  if ! git pull --rebase --quiet origin master; then
    fail "could not update $repo"
  fi
  success "updated $repo"
  popd >> /dev/null
done

info 'updating homebrew'
brew update > /dev/null
info 'upgrading homebrew formulas'
brew upgrade > /dev/null
brew cleanup > /dev/null

info "update complete!"
