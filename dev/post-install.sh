for java in $(find /Library/Java/JavaVirtualMachines -mindepth 1 -maxdepth 1 ! -type l); do yes | (jenv add "$java/Contents/Home" & > /dev/null); done
wait
(jenv rehash &) 2> /dev/null
