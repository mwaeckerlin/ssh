#!/bin/bash

id $USER > /dev/null 2>&1 || adduser $USER
/usr/sbin/sshd -D
