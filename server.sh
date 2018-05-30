#!/bin/bash -e

/etc/init.d/nscd start
if test -n "${SSHKEY}"; then
    test -d ~/.ssh || mkdir ~/.ssh
    echo -e "${SSHKEY}"  > ~/.ssh/authorized_keys
fi
for f in /etc/ssh/*key*; do
    test -e "/keys/${f##*/}" || cp "$f" "/keys/${f##*/}"
done
echo "setup ready, starting ssh daemon ..."
/usr/sbin/sshd $SSHOPTIONS -D
