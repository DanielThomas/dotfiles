# Danny's dotfiles #

Opinionated dotfiles repository for Mac OS with zsh, solarised and oh-my-zsh with the Agnoster theme.

Based on Zach Holman's dotfiles - https://github.com/holman/dotfiles.

## Install ##

- Clone the repository `git clone ssh://git@stash.cloud.local/~dthomas/dotfiles.git ~/.dotfiles`
- Run the bootstrap to install the files `cd ~/.dotfiles; ./bootstrap.sh`

## Components ##

- `path.zsh`: Loaded first, and expected to setup `$PATH`
- `*.zsh`: Get loaded into your environment
- `completion.zsh`: Loaded last, and expected to setup autocomplete
- `*.symlink`: Automaticlly symlinked into your `$HOME` as a dot file during bootstrap
- `otf`: Open type files are copied to `~/Library/Fonts` during bootstrap
- `plist`: Preference lists are copied to `~/Library/Preferences` during bootstrap

### Installers ###

Installation steps during bootstrap can be handled in three ways:

- `install.sh`: An installation shellscript, executed by bootstrap
- `install.homebrew`: A list of Homebrew formulas to install
- `install.open`: A list of files
