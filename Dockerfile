FROM ubuntu:latest
MAINTAINER mwaeckerlin
ENV TERM xterm

ENV USER "user"
EXPOSE 22

RUN apt-get update
RUN apt-get -y install rsync openssh-server emacs24-nox
RUN mkdir /var/run/sshd
RUN sed -i 's,^ *PermitEmptyPasswords .*,PermitEmptyPasswords yes,' /etc/ssh/sshd_config
RUN sed -i '1iauth sufficient pam_permit.so' /etc/pam.d/sshd
ADD start.sh /start.sh
CMD /start.sh
