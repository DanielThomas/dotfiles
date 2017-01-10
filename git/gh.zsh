#!/bin/sh
  
gh_help(){
    echo "Usage: gh <subcommand> [options]\n"
    echo "Subcommands:"
    echo "    browse   Open a GitHub project page in the default browser"
    echo "    cd       Go to the directory of the specified repository"
    echo "    clone    Clone a remote repository"
    echo ""
    echo "For help with each subcommand run:"
    echo "gh <subcommand> -h|--help"
    echo ""
}
  
gh_browse() {
    open `git remote -v | awk '/fetch/{print $2}' | sed -Ee 's#(git@|git://)#http://#' -e 's@com:@com/@'`| head -n1
}
  
gh_clone() {
    git clone "ssh://git@github.com/$1.git" ~/Projects/github/$1
    gh_cd "$1"
}

gh_cd() {
    cd ~/Projects/github/$1
}

gh() {
    subcommand=$1
    case $subcommand in
        "" | "-h" | "--help")
            gh_help
            ;;
        *)
            shift
            gh_${subcommand} $@
            if [ $? = 127 ]; then
                echo "Error: '$subcommand' is not a known subcommand." >&2
                echo "       Run 'ghs --help' for a list of known subcommands." >&2
                return 1
            fi
            ;;
    esac
}

compdef '_files -W ~/Projects/github' gh
