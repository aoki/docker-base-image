#!/bin/sh -eu

readonly WORK_DIR="/vagrant"
DOCKER_HUB_USER=${1}
DOCKER_HUB_PASSWORD=${2}
DOCKER_HUB_EMAIL=${3}
VERSION=${4}

cd ${WORK_DIR}

# Install supermin and libdevmapper
yum --releasever=${VERSION} install -y supermin5 libdevmapper.so.1.02

# Build
supermin5 --prepare yum -o supermin.d && \
  supermin5 --build --format chroot supermin.d -o appliance.d

# Remove locales
readonly LOCALE_DIR=${WORK_DIR}/appliance.d/usr/share/locale
mv ${LOCALE_DIR}/en ${LOCALE_DIR}/en_US /tmp/ && \
  rm -rf ${LOCALE_DIR}/* && \
  mv /tmp/en /tmp/en_US ${LOCALE_DIR}/

# Remove i18ns
readonly I18N_DIR=${WORK_DIR}/appliance.d/usr/share/i18n/locales
mv ${I18N_DIR}/en_US /tmp/ && \
  rm -rf ${I18N_DIR}/*  && \
  mv /tmp/en_US ${I18N_DIR}/

# Create tarball and compress
cd ${WORK_DIR}/appliance.d && \
  tar --create . | xz --best > ${WORK_DIR}/scientific-linux_${VERSION}_x86_64.tar.xz

# Install the docker
curl -sSL https://get.docker.com/ | sh || :

# docker import and push
service docker start
cat ${WORK_DIR}/scientific-linux_${VERSION}_x86_64.tar.xz | docker import - ringo/scientific:${VERSION} && \
  docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD} -e "${DOCKER_HUB_EMAIL}"
  docker push ringo/scientific:${VERSION}

# Clean directory
rm -rf appliance.d supermin.d *.tar.xz