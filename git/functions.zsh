# gitignore.io - http://www.gitignore.io/cli
function gi() { curl http://www.gitignore.io/api/$@ ;}

function bb() {
    FETCH_URL=$(git remote -v | grep git@ | grep fetch | head -1 | cut -f2 | cut -d ' ' -f 1 | sed 's#ssh://git@##')
    FETCH_HOST=$(echo "$FETCH_URL" | grep -o '[^:]*')
    FETCH_PATH=$(echo "$FETCH_URL" | grep -o '/.*')
    PROJECT=$(echo "$FETCH_PATH" | cut -d '/' -f 2)
    REPO=$(echo "$FETCH_PATH" | cut -d '/' -f 3 | sed 's/\.git//')
    open "https://$FETCH_HOST/projects/$PROJECT/repos/$REPO/browse"
}
