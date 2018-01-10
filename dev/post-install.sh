for java in /Library/Java/JavaVirtualMachines/*; do yes | jenv add "$java/Contents/Home" > /dev/null; done
