FROM mwaeckerlin/ubuntu-base
MAINTAINER mwaeckerlin

ENV SSHOPTIONS "-e"
ENV SSHKEY ""
ENV LDAPURI ""
ENV LDAPBASE ""
ENV LDAPROOTBINDDN ""
ENV LDAPROOTBINDPW ""
ENV LDAPBINDDN ""
ENV LDAPBINDPW ""
ENV LDAPSCOPE ""
ENV LDAPDEREF ""
ENV LDAPTIMELIMIT ""
ENV LDAPBIND_TIMELIMIT ""
ENV LDAPSSL ""
ENV LDAPPAM_FILTER ""
ENV LDAPPAM_LOGIN_ATTRIBUTE ""
ENV LDAPPAM_CHECK_HOST_ATTR ""
ENV LDAPPAM_CHECK_SERVICE_ATTR ""
ENV LDAPPAM_GROUPDN ""
ENV LDAPPAM_MEMBER_ATTRIBUTE ""
ENV LDAPPAM_MIN_UID ""
ENV LDAPPAM_MAX_UID ""
ENV LDAPBASE_USER_DN ""
ENV LDAPBASE_GROUP_DN ""
ENV LDAPBASE_HOST_DN ""
ENV LDAPNSS_BASE_PASSWD ""
ENV LDAPNSS_BASE_SHADOW ""
ENV LDAPNSS_BASE_GROUP ""
ENV LDAPNSS_BASE_HOSTS ""
ENV LDAPNSS_BASE_SERVICES ""
ENV LDAPNSS_BASE_NETWORKS ""
ENV LDAPNSS_BASE_PROTOCOLS ""
ENV LDAPNSS_BASE_RPC ""
ENV LDAPNSS_BASE_ETHERS ""
ENV LDAPNSS_BASE_NETMASKS ""
ENV LDAPNSS_BASE_BOOTPARAMS ""
ENV LDAPNSS_BASE_ALIASES ""
ENV LDAPNSS_BASE_NETGROUP ""

EXPOSE 22

RUN echo "ldap-auth-config ldap-auth-config/move-to-debconf boolean false" | debconf-set-selections \
 && $PKG_INSTALL language-pack-en libpam-ldap nscd openssh-server emacs-nox rsync \
 && /cleanup.sh \
 && sed -i 's,\(\(passwd\|group\|shadow\): *\),\1ldap ,' /etc/nsswitch.conf \
 && echo "session required    pam_mkhomedir.so skel=/etc/skel umask=0022" >> /etc/pam.d/common-session \
 && mkdir /var/run/sshd

ADD sshd_config /etc/ssh/sshd_config
ADD config-ldap.sh /config-ldap.sh
ADD server.sh /server.sh
ADD start.sh /start.sh
CMD /start.sh

VOLUME /home
VOLUME /keys