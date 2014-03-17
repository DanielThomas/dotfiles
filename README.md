# Danny's dotfiles #

Opinionated dotfiles repository for Mac OS with zsh. Including Homebrew, Solarised and oh-my-zsh with the Agnoster theme.

Based on Zach Holman's dotfiles - https://github.com/holman/dotfiles.

## Prerequisites ##

- Set `zsh` as your default shell: `chsh -s /bin/zsh`. Optionally, use Homebew to install the latest zsh and use `/usr/local/bin/zsh`
- For best results, use iTerm2 as your terminal

## Install ##

- Clone the repository `git clone ssh://git@stash.cloud.local/~dthomas/dotfiles.git ~/.dotfiles`
- Run the bootstrap to install the files `cd ~/.dotfiles; ./bootstrap.sh`

## Update ##

- `git pull --rebase` the repository periodically
- `cd ~/.dotfiles; ./update.sh` to update any cloned git repositories

## Components ##

Files are processed automatically depending on their extension, they set the environment, install files or perform post-installation steps depending on the file name or extension.

### Environment ###

These files set your shell's environment:

- `path.zsh`: Loaded first, and expected to setup `$PATH`
- `*.zsh`: Get loaded into your environment
- `completion.zsh`: Loaded last, and expected to setup autocomplete

## Files ##

These cause files to be created in your home directory:

- `*.symlink`: Automaticlly symlinked into your `$HOME` as a dot file during bootstrap. For example, `myfile.symlink` will be linked as `$HOME/.myfile`
- `*.gitrepo`: Contains a URL to a Git repository to be cloned as a dotfile. For example `myrepo.symlink` will be cloned to `$HOME/.myrepo`
- `*.gitpatch`: Name `repo-<number>.gitpatch` to apply custom patches to a `gitrepo` repository
- `*.otf`: Open type files are copied to `~/Library/Fonts` during bootstrap
- `*.plist`: Preference lists are copied to `~/Library/Preferences` during bootstrap

### Installers ###

Installation steps during bootstrap can be handled in three ways:

- `install.sh`: An installation shellscript, executed by bootstrap
- `install.homebrew`: A list of Homebrew formulas to install
- `install.open`: A list of files

## Private configuration ##

Use `~/.localrc` to configure anything that you want to keep private. By default, set `DEFAULT_USER` to your main username:

`export DEFAULT_USER=dthomas`
