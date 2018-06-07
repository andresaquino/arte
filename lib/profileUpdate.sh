#!/bin/bash
# vim: si ai ft=sh:

# (c) 2017, Andres Aquino <inbox(at)andresaquino.sh>
# This file is licensed under the BSD License version 3 or later.
# See the LICENSE file.

# TODO
# 1: extraer archivos del ultimo package
# 2: mover el directorio arte a respaldo y colocar el nuevo
# 3: sustituir configuracion anterior por la nueva

# FIXME - tomar el ultimo package, extraer y comenzar a sustituir archivos
if [ -d ${HOME}/arte ]; then
  LASTDATE="$(date '+%m%d%H%M')"
  mv ${HOME}/arte ${HOME}/arte-${LASTDATE}
  echo "backup last profile in ${HOME}/arte-${LASTDATE}"
fi

# FIXME - integrar la ultima configuracion, no eliminar archivos
if [ -d ${HOME}/arte.git ]; then
  # renaming
  mv ${HOME}/arte.git ${HOME}/arte

  # creating new links
  echo "Instructions:"
  echo "$> sudo rm -fr /usr/local/arte"
  echo "$> sudo mkdir -p /usr/local/arte"
  echo "$> sudo rsync -av ${HOME}/arte/* /usr/local/arte/ --exclude=packages"
  echo "$> sudo ln -sf /usr/local/arte/etc/shell.profile /usr/local/shell.profile"
  echo "$> sudo ln -sf /usr/local/arte/etc/unix.profile /usr/local/unix.profile"
  echo "$> sudo ln -sf /usr/local/arte/logo.d/default.info /usr/local/logo.info"
  echo "$> sudo find /usr/local/arte -type d -exec chmod a+rx {} \;"
  echo "$> sudo find /usr/local/arte -type f -exec chmod a+r {} \;"

  # using r00t
  if [ ${USER} = "root" ]; then
    rm -fr /usr/local/arte
    mkdir -p /usr/local/arte
    rsync -av ${HOME}/arte/* /usr/local/arte/ --exclude=packages
    ln -sf /usr/local/arte/etc/shell.profile /usr/local/shell.profile
    ln -sf /usr/local/arte/etc/unix.profile /usr/local/unix.profile
    ln -sf /usr/local/arte/logo.d/default.info /usr/local/logo.info
    find /usr/local/arte -type d -exec chmod a+rx {} \;
    find /usr/local/arte -type f -exec chmod a+r {} \;

  fi

  [ -L ${HOME}/.vim ] && unlink ${HOME}/.vim
  ln -sf ${HOME}/arte/etc/vim.setup/vimdir ${HOME}/.vim
  [ -L ${HOME}/.vimrc ] && unlink ${HOME}/.vimrc
  ln -sf ${HOME}/arte/etc/vim.profile ${HOME}/.vimrc
  find ${HOME}/arte -type d -exec chmod a-rwx,u+rwx,g+rx {} \;
  find ${HOME}/arte -type f -exec chmod a-rwx,u+rw,g+r {} \;

  # copying bash profile
  cp ${HOME}/arte/etc/shell.setup/bash.rc ${HOME}/.bashrc
  cp ${HOME}/arte/etc/shell.setup/bash.profile ${HOME}/.bash_profile

  # migration of oldest config
  cp -r ${HOME}/arte/paths.d ${HOME}/
  if [ -d ${HOME}/arte-${LASTDATE}/paths.d/ ]; then
    cp -r ${HOME}/arte-${LASTDATE}/paths.d/* ${HOME}/paths.d/
  fi

  local_prof="${HOME}/$(hostname -s).profile"
  if [ -f ${local_prof} ]; then
    echo "Update your ${local_prof}"
    diff ${local_prof} ${HOME}/arte/etc/userenv.profile
  else
    cp -r ${HOME}/arte/etc/default.profile ${HOME}/.profile
    cp -r ${HOME}/arte/etc/userenv.profile ${HOME}/$(hostname -s).profile
  fi

  # ssh setup
  if [ -d ${HOME}/.ssh ]; then
    echo "Update your keys in .ssh/authorized_keys"

  else
    mkdir -p ${HOME}/.ssh
    chmod 0700 ${HOME}/.ssh
    cp ${HOME}/arte/etc/ssh.setup/authorized_keys-default.cnf ${HOME}/.ssh/authorized_keys
    cp ${HOME}/arte/etc/ssh.setup/config-default.cnf ${HOME}/.ssh/config
    chmod 0600 ${HOME}/.ssh/*

  fi

  # last backup
  if [ -d ${HOME}/arte-${LASTDATE} ]; then
    tar --exclude='packages' \
      --exclude='.git' \
      -z -c -v -f ${HOME}/arte/packages/arte_${LASTDATE}_backup.tar.gz ${HOME}/arte-${LASTDATE}
    rm -f ${HOME}/arte-${LASTDATE}/
  fi

fi

