#!/usr/bin/env bash
# (c) 2018, Andres Aquino <inbox(at)andresaquino.sh>
# This file is licensed under the BSD License version 3 or later.
# See the LICENSE file.

# v0.1.6
__appTag="$(git tag -l | tail -1)"
__appName="arte"
__appHome="$(pwd)"
if [ ! -f "${__appHome}/etc/unixrc" ];
then
   echo "Run in project directory."
   exit -1
else
   # go home babe
   cd ${__appHome}
   
   # naming vars
   __appPackage="${__appName}-${__appTag}"
   __appFileName="${__appPackage}.tar.gz"
   __appPckgName="${__appHome}/tmp/${__appFileName}"
   
   # if exists, delete
   [[ -f "${__appPckgName}" ]] && rm -fr "${__appPckgName}"

   # and create with tar
   echo "Create package ${__appPackage}.tar.gz"
   tar -c -v -f "${__appPckgName}" \
      --exclude=tmp/*.* \
	   --exclude=log/*.* \
	   --exclude=paths.d/*.path \
	   --exclude=vim.setup/iTerm* \
	   --exclude=docker  \
	   --exclude=legacy  \
	   --exclude=sandbox \
	   --exclude=.git . > "${__appHome}/log/${__appTag}.log" 2>&1

   # get signature
   echo "Ready, creating signature and final pkg."
   openssl dgst -md5 "${__appPckgName}" > "${__appHome}/tmp/${__appPackage}.md5"

fi
