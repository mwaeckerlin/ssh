#!/bin/bash -e

function dn() {
    if test -n "$1" -a -n "$LDAPBASE"; then
        echo ${1%,$LDAPBASE},$LDAPBASE
    else
        echo $1
    fi
}
function optional() {
    if test -n "$2"; then
        echo "$1 $2" >> /etc/ldap.conf
    fi
}

if test -z "$LDAPURI" -a -n "$LDAP_ENV_DOMAIN"; then
    # get LDAPURI from docker link
    export LDAPURI="ldap://$LDAP_ENV_DOMAIN"
fi
if test -z "$LDAPBASE" -a -n "$LDAPURI"; then
    # get base from server
    LDAPBASE="${LDAPURI#*://}"
    LDAPBASE="${LDAPBASE%:*}"
    export LDAPBASE="dc=${LDAPBASE//./,dc=}"
fi

# configure ldap
cat > /etc/ldap.conf <<EOF
base $LDAPBASE
uri $LDAPURI
ldap_version 3
pam_password md5
EOF
if test -n "$LDAPBINDDN" -a -n "$LDAPBINDPW"; then
    cat >> /etc/ldap.conf <<EOF
binddn $(dn $LDAPBINDDN)
bindpw $LDAPBINDPW
EOF
fi
if test -n "$LDAPROOTBINDDN" -a -n "$LDAPROOTBINDPW"; then
    cat >> /etc/ldap.conf <<EOF
rootbinddn $(dn $LDAPROOTBINDDN)
EOF
    cat > /etc/ldap.secret <<EOF
$LDAPROOTBINDPW
EOF
    chmod go= /etc/ldap.secret
fi
optional scope $LDAPSCOPE
optional deref $LDAPDEREF
optional timelimit $LDAPTIMELIMIT
optional bind_timelimit $LDAPBIND_TIMELIMIT
optional ssl $LDAPSSL
optional pam_filter $LDAPPAM_FILTER
optional pam_login_attribute $LDAPPAM_LOGIN_ATTRIBUTE
optional pam_check_host_attr $LDAPPAM_CHECK_HOST_ATTR
optional pam_check_service_attr $LDAPPAM_CHECK_SERVICE_ATTR
optional pam_groupdn $LDAPPAM_GROUPDN
optional pam_member_attribute $LDAPPAM_MEMBER_ATTRIBUTE
optional pam_min_uid $LDAPPAM_MIN_UID
optional pam_max_uid $LDAPPAM_MAX_UID

# additional optional ldap authentication and search parameters
# To just set user, group and host dn, use LDAPBASEUSERDN, LDAPBASEGROUPDN, LDAPBASEHOSTDN
LDAPNSS_BASE_PASSWD=${LDAPNSS_BASE_PASSWD:-${LDAPBASEUSERDN:-$LDAPNSS_BASE_SHADOW}}
LDAPNSS_BASE_SHADOW=${LDAPNSS_BASE_SHADOW:-${LDAPBASEUSERDN:-$LDAPNSS_BASE_PASSWD}}
LDAPNSS_BASE_GROUP=${LDAPNSS_BASE_GROUP:-$LDAPBASEGROUPDN}
LDAPNSS_BASE_HOSTS=${LDAPNSS_BASE_HOSTS:-$LDAPBASEHOSTDN}
# if the parameter is unset, just the default is used and it is not appended to /etc/ldap.conf
optional nss_base_passwd $(dn $LDAPNSS_BASE_PASSWD)
optional nss_base_shadow $(dn $LDAPNSS_BASE_SHADOW)
optional nss_base_group $(dn $LDAPNSS_BASE_GROUP)
optional nss_base_hosts $(dn $LDAPNSS_BASE_HOSTS)
optional nss_base_services $(dn $LDAPNSS_BASE_SERVICES)
optional nss_base_networks $(dn $LDAPNSS_BASE_NETWORKS)
optional nss_base_protocols $(dn $LDAPNSS_BASE_PROTOCOLS)
optional nss_base_rpc $(dn $LDAPNSS_BASE_RPC)
optional nss_base_ethers $(dn $LDAPNSS_BASE_ETHERS)
optional nss_base_netmasks $(dn $LDAPNSS_BASE_NETMASKS)
optional nss_base_bootparams $(dn $LDAPNSS_BASE_BOOTPARAMS)
optional nss_base_aliases $(dn $LDAPNSS_BASE_ALIASES)
optional nss_base_netgroup $(dn $LDAPNSS_BASE_NETGROUP)
