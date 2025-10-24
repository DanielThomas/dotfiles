GITHUB_DIR="$HOME/Projects/github"

ghclone() {
    if [ -z "$1" ]; then
        echo "No repository provided"
        return 1
    else
        repodir="$GITHUB_DIR/$1"
        if [ ! -d "$repodir" ]; then
            if [[ "$1" == corp/* ]]; then
                GH_HOST="$GHE_HOST" gh repo clone "$1" "$repodir"
            else
                gh repo clone "$1" "$repodir"
            fi
        fi
        cd "$repodir"
    fi
}
