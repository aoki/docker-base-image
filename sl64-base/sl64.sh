#!/bin/sh

MIRROR_URL="http://ftp.riken.jp/Linux/scientific/6.4/x86_64/os/"
MIRROR_URL_UPDATES="http://ftp.riken.jp/Linux/scientific/6.4/x86_64/updates/security/"

yum install -y febootstrap xz

febootstrap -i bash -i coreutils -i tar -i bzip2 -i gzip -i vim-minimal -i wget -i patch -i diffutils -i iproute -i yum scientific scientific64  $MIRROR_URL -u $MIRROR_URL_UPDATES
touch scientific64/etc/resolv.conf
touch scientific64/sbin/init

tar --numeric-owner -Jcpf scientific-64.tar.xz -C scientific64 .
