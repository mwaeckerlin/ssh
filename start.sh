#!/bin/bash

id $USER > /dev/null 2>&1 || useradd $USER

/usr/sbin/sshd -D
