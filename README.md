# ssh

Docker Image for SSH  Server to provide remote access to volumes, i.e.using rsync

Can get Users from LDAP, e.g.:

    docker run -d --name ssh -p 222:22 \
        -e LDAP_SERVER="ldap://my.example.com" \
        -e LDAP_BIND="cn=ssh-bind,ou=system,ou=people" \
        -e LDAP_BINDPW="H2Djds4ZAhsa" \
        mwaeckerlin/ssh
