#!/bin/bash
# vim: si ai ft=sh:

# (c) 2018, Andres Aquino <inbox(at)andresaquino.sh>
# This file is licensed under the BSD License version 3 or later.
# See the LICENSE file.

# go home babe
# export DIST_HOME="Path of arte"
PACK_VERSION=1.0
[ ! -d ${DIST_HOME} ] && exit -1

# yeah
cd ${DIST_HOME}
[ ! -f VERSION ] && PACK_VERSION=$(cat VERSION)
VERSION=1.0
PACK_NAME="arte"
PACK_RELEASE="${U_DATE:2:4}"
PACK_DIST="${PACK_NAME}-v${PACK_VERSION}.${PACK_RELEASE}"

# create pkgs
echo "Compressing ${PACK_DIST} with ${COMPRESS}"
[ -f pkgs/${PACK_DIST}.tar.gz ] && rm -fr pkgs/${PACK_NAME}*
tar -c -v -f pkgs/${PACK_DIST}.tar.gz \
	--exclude=tmp/*.* \
	--exclude=log/*.* \
	--exclude=pkgs/*.* \
	--exclude=paths.d/*.path \
	--exclude=vim.setup/iTerm* \
	--exclude=docker  \
	--exclude=legacy  \
	--exclude=sandbox \
	--exclude=.git . > log/${PACK_DIST}.log 2>&1

# create a dist package and sign
cd pkgs
echo "Ready, creating signature and final pkg."
cp -p ${PACK_DIST}.tar.gz ${PACK_NAME}.tar.gz
openssl dgst -md5 ${PACK_NAME}.tar.gz > ${PACK_NAME}.md5

