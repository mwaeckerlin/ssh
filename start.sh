#!/bin/bash -e

if test -z "$LDAP_SERVER" -a -n "$LDAP_ENV_DOMAIN"; then
    # get LDAP_SERVER from docker link
    export LDAP_SERVER="ldap://$LDAP_ENV_DOMAIN"
fi
if test -z "$LDAP_BASE" -a -n "$LDAP_SERVER"; then
    # get base from server
    LDAP_BASE="${LDAP_SERVER#*://}"
    LDAP_BASE="${LDAP_BASE%:*}"
    export LDAP_BASE="dc=${LDAP_BASE//./,dc=}"
fi
if test -n "LDAP_ROOT" -a "${LDAP_ROOT/,dc=/}" = "${LDAP_ROOT}" -a -n "$LDAP_BASE"; then
    # append base to LDAP_ROOT
    export LDAP_ROOT="${LDAP_ROOT},${LDAP_BASE}"
fi
if test -n "LDAP_BIND" -a "${LDAP_BIND/,dc=/}" = "${LDAP_BIND}" -a -n "$LDAP_BASE"; then
    # append base to LDAP_BIND
    export LDAP_BIND="${LDAP_BIND},${LDAP_BASE}"
fi

# configure ldap
cat > /etc/ldap.conf <<EOF
base $LDAP_BASE
uri $LDAP_SERVER
ldap_version 3
pam_password md5
EOF
if test -n "$LDAP_BIND" -a -n "$LDAP_BINDPW"; then
    cat >> /etc/ldap.conf <<EOF
binddn $LDAP_BIND
bindpw $LDAP_BINDPW
EOF
fi
if test -n "$LDAP_ROOT" -a -n "$LDAP_ROOTPW"; then
    cat >> /etc/ldap.conf <<EOF
rootbinddn $LDAP_ROOT
EOF
    cat > /etc/ldap.secret <<EOF
$LDAP_ROOTPW
EOF
    chmod go= /etc/ldap.secret
fi

/etc/init.d/nscd start
/usr/sbin/sshd -D
