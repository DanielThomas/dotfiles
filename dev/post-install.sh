for java in /Library/Java/JavaVirtualMachines/*; do yes | jenv add "$java/Contents/Home" > /dev/null; done
(jenv rehash &) 2> /dev/null
