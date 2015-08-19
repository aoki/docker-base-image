#!/bin/sh -eu

readonly CMD_PATH=$(cd `dirname ${0}` && pwd)

yum install -y supermin5

supermin5 --prepare yum -o supermin.d && \
  supermin5 --build --format chroot supermin.d -o appliance.d

mv ${CMD_PATH}/appliance.d/usr/share/locale/en ${CMD_PATH}/appliance.d/usr/share/locale/en_US ${CMD_PATH}/appliance.d/tmp && \
  rm -rf ${CMD_PATH}/appliance.d/usr/share/locale/* && \
  mv ${CMD_PATH}/appliance.d/tmp/en ${CMD_PATH}/appliance.d/tmp/en_US ${CMD_PATH}/appliance.d/usr/share/locale/
mv ${CMD_PATH}/appliance.d/usr/share/i18n/locales/en_US ${CMD_PATH}/appliance.d/tmp && \
  rm -rf ${CMD_PATH}/appliance.d/usr/share/i18n/locales/*  && \
  mv ${CMD_PATH}/appliance.d/tmp/en_US ${CMD_PATH}/appliance.d/usr/share/i18n/locales/

cd ${CMD_PATH}/appliance.d && tar --create . | xz --best > /vagrant/scientific-linux_7.1_x86_64.tar.xz
