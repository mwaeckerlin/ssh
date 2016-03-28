FROM ubuntu:latest
MAINTAINER mwaeckerlin
ENV TERM "xterm"
ENV DEBIAN_FRONTEND "noninteractive"

ENV LDAP_SERVER ""
ENV LDAP_BASE ""
ENV LDAP_ROOT ""
ENV LDAP_ROOTPW ""
ENV LDAP_BIND ""
ENV LDAP_BINDPW ""

EXPOSE 22

RUN echo "ldap-auth-config ldap-auth-config/move-to-debconf boolean false" | debconf-set-selections
RUN apt-get update
RUN apt-get -y install libpam-ldap nscd openssh-server emacs24-nox rsync
RUN sed -i 's,\(\(passwd\|group\|shadow\): *\),\1ldap ,' /etc/nsswitch.conf
RUN echo "session required    pam_mkhomedir.so skel=/etc/skel umask=0022" >> /etc/pam.d/common-session
RUN mkdir /var/run/sshd

ADD start.sh /start.sh
CMD /start.sh

VOLUME /home
