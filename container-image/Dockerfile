FROM docker.io/almalinux:8
RUN curl -o /etc/yum.repos.d/bareos.repo -O https://download.bareos.org/bareos/release/21/EL_8/bareos.repo \
 && dnf install -y \
  bareos-filedaemon \
  mysql \
 && dnf clean all
COPY *.* /
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "-f" ]
