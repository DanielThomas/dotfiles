eval "$(jenv init - --no-rehash)"
(jenv rehash &) 2> /dev/null
jenv enable-plugin export
