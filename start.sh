#!/bin/bash

id $USER > /dev/null 2>&1 || useradd -s /bin/bash $USER

/usr/sbin/sshd -D
