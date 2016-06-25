#!/bin/bash -e

/etc/init.d/nscd start
if test -n "${SSHKEY}"; then
    test -d ~/.ssh || mkdir ~/.ssh
    cat > ~/.ssh/authorized_keys <<EOF
${SSHKEY}
EOF
fi
echo "setup ready, starting ssh daemon ..."
/usr/sbin/sshd $SSHOPTIONS -D
