#!/bin/bash -e

/etc/init.d/nscd start
/usr/sbin/sshd -D
