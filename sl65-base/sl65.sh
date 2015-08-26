#!/bin/sh

MIRROR_URL="http://ftp.riken.jp/Linux/scientific/6.6/x86_64/os/"
MIRROR_URL_UPDATES="http://ftp.riken.jp/Linux/scientific/6.6/x86_64/updates/security/"

yum install -y febootstrap xz

febootstrap -i yum \
  scientific scientific66 ${MIRROR_URL} -u ${MIRROR_URL_UPDATES}
touch scientific66/etc/resolv.conf
touch scientific66/sbin/init

tar --numeric-owner -Jcpf scientific-66.tar.xz -C scientific66 .
