#!/usr/bin/env bash
#
# update bootstrapped resources

source scripts/common.sh

for file in `find $DOTFILES_ROOT -maxdepth 2 -name \*.gitrepo`; do
  repo="$HOME/.`basename \"${file%.*}\"`"
  pushd $repo >> /dev/null
  if ! git pull --rebase --quiet origin master; then
    fail "could not update $repo"
  fi
  success "updated $repo"
  popd >> /dev/null
done

info "update complete!"