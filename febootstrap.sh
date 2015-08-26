#!/bin/sh -eu

#readonly WORK_DIR="/"
DOCKER_HUB_USER=${1}
DOCKER_HUB_PASSWORD=${2}
DOCKER_HUB_EMAIL=${3}
VERSION=${4}

readonly MIRROR_URL="http://ftp.riken.jp/Linux/scientific/${VERSION}/x86_64/os/"
readonly MIRROR_URL_UPDATES="http://ftp.riken.jp/Linux/scientific/${VERSION}/x86_64/updates/security/"

yum install -y febootstrap xz libdevmapper.so.1.0

febootstrap -i yum -i sl-release \
  scientific scientific-${VERSION} ${MIRROR_URL} -u ${MIRROR_URL_UPDATES}
touch scientific-${VERSION}/etc/resolv.conf
touch scientific-${VERSION}/sbin/init

tar --numeric-owner -Jcpf scientific-linux_${VERSION}_x86_64.tar.xz -C scientific-${VERSION} .

# Install the docker
curl -sSL https://get.docker.com/ | sh || :

# docker import and push
service docker start
cat scientific-linux_${VERSION}_x86_64.tar.xz | docker import - ringo/scientific:${VERSION} && \
  docker login -u ${DOCKER_HUB_USER} -p ${DOCKER_HUB_PASSWORD} -e "${DOCKER_HUB_EMAIL}" && \
  docker push ringo/scientific:${VERSION}