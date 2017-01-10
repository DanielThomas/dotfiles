#!/bin/sh
  
bb_help(){
    echo "Usage: bb <subcommand> [options]\n"
    echo "Subcommands:"
    echo "    browse   Open a BitBucket page in the default browser"
    echo "    cd       Go to the directory of the specified repository"
    echo "    clone    Clone a remote repository"
    echo ""
    echo "For help with each subcommand run:"
    echo "bb <subcommand> -h|--help"
    echo ""
}
  
bb_browse() {
    FETCH_URL=$(git remote -v | grep git@ | grep fetch | head -1 | cut -f2 | cut -d ' ' -f 1 | sed 's#ssh://git@##')
    FETCH_HOST=$(echo "$FETCH_URL" | grep -o '[^:]*')
    FETCH_PATH=$(echo "$FETCH_URL" | grep -o '/.*')
    PROJECT=$(echo "$FETCH_PATH" | cut -d '/' -f 2)
    REPO=$(echo "$FETCH_PATH" | cut -d '/' -f 3 | sed 's/\.git//')
    open "https://$FETCH_HOST/projects/$PROJECT/repos/$REPO/browse"
}
  
bb_clone() {
    : ${BB_HOST?"BB_HOST must be set"}
    git clone "ssh://git@$BB_HOST/$1.git" ~/Projects/bb/$1
    bb_cd "$1"
}

bb_cd() {
    cd ~/Projects/bb/$1
}

bb() {
    subcommand=$1
    case $subcommand in
        "" | "-h" | "--help")
            bb_help
            ;;
        *)
            shift
            bb_${subcommand} $@
            if [ $? = 127 ]; then
                echo "Error: '$subcommand' is not a known subcommand." >&2
                echo "       Run 'bb --help' for a list of known subcommands." >&2
                return 1
            fi
            ;;
    esac
}

compdef '_files -W ~/Projects/bb' bb
