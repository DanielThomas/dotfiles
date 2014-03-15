function daily {
  echo "Updating Development Tools"
  p4 sync //DIRE/projects/...
  echo "Updating B2 Projects"
  cd ~/Code/projects
  git p4r
  echo "Updating Learn"
  cd $LEARN_MAINLINE
  git p4r
  cd projects
  echo "Cleanup Gradle daemons, refresh dependencies and generate IntelliJ projects"
  gdl --stop
  gdl --refresh-dependencies idea
  echo "Installing primary Learn instance"
  learn
  ./build clean
  ./build refresh install
}

function weekly {
  upgrade_oh_my_zsh
  echo "Dumping Homebrew configuration"
  brew list > ~/Code/brew-formulas
  brew tap > ~/Code/brew-taps
  echo "Updating Homebrew"
  brew update
  brew doctor
  echo "Outdated Homebrew formulas:"
  brew outdated
}

function monthly {
  echo "Updating Blog mirror"
  pushd ~/Websites/Blog > /dev/null
  httrack --update http://silicon.pd.local/display/\~dthomas/Blog+Archive "+silicon.pd.local/s/*" "+silicon.pd.local/images/*" "+silicon.pd.local/download/*"
  popd > /dev/null
}
