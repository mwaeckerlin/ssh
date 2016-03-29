# ssh

Docker Image for SSH  Server to provide remote access to volumes, i.e.using rsync

Can get Users from LDAP, e.g.:

    docker run -d --name ssh -p 222:22 \
        -e LDAPURI="ldap://my.example.com" \
        -e LDAPBINDDN="cn=ssh-bind,ou=system,ou=people" \
        -e LDAPBINDPW="H2Djds4ZAhsa" \
        -e LDAPBASEUSERDN="ou=person,ou=people," \
        -e LDAPBASEGROUPDN="ou=group," \
        mwaeckerlin/ssh
