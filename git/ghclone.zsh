GITHUB_DIR="$HOME/Projects/github"

ghclone() {
    if [ -z "$1" ]; then
        echo "No repository provided"
        return 1
    else
        repodir="$GITHUB_DIR/$1"
        if [ ! -d "$repodir" ]; then
            gh repo clone "$1" "$repodir"
        fi
        cd "$repodir"
    fi
}
