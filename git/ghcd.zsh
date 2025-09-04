GITHUB_DIR="$HOME/Projects/github"

ghcd() {
    if [ -z "$1" ]; then
        cd "$GITHUB_DIR"
    else
        cd "$GITHUB_DIR/$1"
    fi
}

compdef '_files -W $GITHUB_DIR' ghcd
