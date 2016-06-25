#!/bin/bash -e

/etc/init.d/nscd start
if test -n "${SSHKEY}"; then
    test -d ~/.ssh || mkdir ~/.ssh
    echo -e "${SSHKEY}"  > ~/.ssh/authorized_keys
fi
echo "setup ready, starting ssh daemon ..."
/usr/sbin/sshd $SSHOPTIONS -D
