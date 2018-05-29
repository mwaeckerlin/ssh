Docker Image for SSH  Server
============================

Used e.g. to provide remote access to volumes, i.e.using rsync.


LDAP-Authentication
-------------------

Can get Users from LDAP, e.g.:

    docker run -d --name ssh -p 222:22 \
        -e LDAPURI="ldap://my.example.com" \
        -e LDAPBINDDN="cn=ssh-bind,ou=system,ou=people" \
        -e LDAPBINDPW="H2Djds4ZAhsa" \
        -e LDAPBASEUSERDN="ou=person,ou=people" \
        -e LDAPBASEGROUPDN="ou=group" \
        -e LDAPSSL="start_tls" \
        mwaeckerlin/ssh

or to connect to LDAP via link:

    docker run -d --name ssh -p 222:22 \
        --link openldap:ldap \
        -e LDAPBINDDN="cn=ssh-bind,ou=system,ou=people" \
        -e LDAPBINDPW="H2Djds4ZAhsa" \
        -e LDAPBASEUSERDN="ou=person,ou=people" \
        -e LDAPBASEGROUPDN="ou=group" \
        mwaeckerlin/ssh


Authentication Using SSH-Keys
-----------------------------

Instead or in addition of LDAP authentication, you can also provide ssh public keys in variable `SSHKEY` (keys are separated by newline). You can then use the given keys to login to root.


X-11 Redirection on Localhost
-----------------------------

Sometimes you might want to test an X11 GUI program in a container on your computer. Thry this:

    docker run -ti --rm \
      --name ssh-container \
      -e "SSHKEY=$(<~/.ssh/id_rsa.pub)" \
      mwaeckerlin/ssh

In a second terminal on the same host:

    ssh -Y root@$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' ssh-container)

Then in the container, you can run whatever GUI program you want, e.g. write:

    apt-get update
    apt-get install xterm
    xterm

Or test even a windows programm, such as [qt linguist](https://github.com/thurask/Qt-Linguist/releases) in the container:

    dpkg --add-architecture i386
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true \
         | debconf-set-selections
    apt update
    apt install -y wine
    wget https://github.com/thurask/Qt-Linguist/releases/download/20171103/linguist.exe
    wine linguist.exe

Starting windows programs with wine in a container on linux, chances to catch a virus are nearly zero.