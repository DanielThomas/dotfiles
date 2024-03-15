#!/bin/sh
  
ghe_help(){
    echo "Usage: ghe <subcommand> [options]\n"
    echo "Subcommands:"
    echo "    browse   Open a GitHub project page in the default browser"
    echo "    cd       Go to the directory of the specified repository"
    echo "    clone    Clone a remote repository"
    echo ""
    echo "For help with each subcommand run:"
    echo "ghe <subcommand> -h|--help"
    echo ""
}
  
ghe_browse() {
    open $(git config --get remote.origin.url)
}
  
ghe_clone() {
    : ${GHE_HOST?"GHE_HOST must be set"}
    git clone --recursive "https://$GHE_HOST/$1.git" ~/Projects/ghe/$1
    ghe_cd "$1"
}

ghe_cd() {
    cd ~/Projects/ghe/$1
}

ghe() {
    subcommand=$1
    case $subcommand in
        "" | "-h" | "--help")
            ghe_help
            ;;
        *)
            shift
            ghe_${subcommand} $@
            if [ $? = 127 ]; then
                echo "Error: '$subcommand' is not a known subcommand." >&2
                echo "       Run 'ghe --help' for a list of known subcommands." >&2
                return 1
            fi
            ;;
    esac
}

compdef '_files -W ~/Projects/ghe' ghe
