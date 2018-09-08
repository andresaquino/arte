#!/bin/bash
# vim: si ai ft=sh:

# (c) 2018, Andres Aquino <inbox(at)andresaquino.sh>
# This file is licensed under the BSD License version 3 or later.
# See the LICENSE file.

# go home babe
# export DIST_HOME="Path of arte"
PACK_VERSION=1.0
if [ ! -d ${DIST_HOME} ];
then
   puts "Please, set DIST_HOME"
   exit -1
else
   # 
   # go home babe
   cd ${DIST_HOME}
   PACK_VERSION=$(cat VERSION)
   PACK_NAME="arte"
   PACK_RELEASE="${U_DATE:2:4}"
   PACK_DIST="${PACK_NAME}-v${PACK_VERSION}.${PACK_RELEASE}"

   # 
   # create tmp/packages
   echo "Compressing ${PACK_DIST} with ${COMPRESS}"
   [ -f tmp/packages/${PACK_DIST}.tar.gz ] && rm -fr tmp/packages/${PACK_NAME}*
   tar -c -v -f tmp/packages/${PACK_DIST}.tar.gz \
	    --exclude=tmp/*.* \
	    --exclude=log/*.* \
	    --exclude=tmp/packages/*.* \
	    --exclude=paths.d/*.path \
	    --exclude=vim.setup/iTerm* \
	    --exclude=docker  \
	    --exclude=legacy  \
	    --exclude=sandbox \
	    --exclude=.git . > log/${PACK_DIST}.log 2>&1

   # 
   # create a dist package and sign
   cd tmp/packages
   echo "Ready, creating signature and final pkg."
   cp -p ${PACK_DIST}.tar.gz ${PACK_NAME}.tar.gz
   openssl dgst -md5 ${PACK_DIST}.tar.gz > ${PACK_DIST}.md5

fi
