#!/bin/bash -e

/etc/init.d/nscd start
echo "setup ready, starting ssh daemon ..."
/usr/sbin/sshd $SSHOPTIONS -D
