alias ls="gls $LS_OPTIONS -h"
alias ll="ls $LS_OPTIONS -l"
alias cd..="cd .."
alias ..="cd .."
alias top="top -o cpu"
alias tf="tail -f"
alias p4r="g p4r"
alias p4s="g p4s"

alias gh="open \`git remote -v | grep git@github.com | grep fetch | head -1 | cut -f2 | cut -d' ' -f1 | sed -e's/:/\//' -e 's/git@/http:\/\//'\`"

alias gw="./gradlew"

alias bup="brew upgrade; brew cleanup"

alias a=ansible
alias ap="ansible-playbook -c ssh"
