# .profile
# vim: si ai ft=sh:

# (c) 2018, Andres Aquino <info(at)andresaquino.sh>
# This file is licensed under the BSD License version 3 or later.
# See the LICENSE file.

#
# Set a java version
java_setversion () {
  JAVA_ENV="${1}"

  # if not exist or is empty, exit
  [ ! -d ${HOME}/paths.d ] || [ -z "$(ls -A ${HOME}/paths.d)" ] && return 0

  # rebuild path and validate
  JAVA_PROF="${HOME}/paths.d/${JAVA_ENV}"
  log_info "[java_setversion] - JAVA Profile ${JAVA_PROF}"

  # Workaround
  # for OS-X systems, java commands are in Commands/ directory
  U_LAND="$(uname -s)"
  BINARIES="bin"

  # workaround hp-ux & java16 & ia64
  [ ${U_LAND} = "HP-UX" ] && [ ${JAVA_ENV} = "java-1.6" ] && BINARIES="${BINARIES}/IA64N" && log_warning "[java_setversion] - Special case, looking for IA64N directory"

  # workaround for Darwin/OS X
  [ ${U_LAND} = "Darwin" ] && BINARIES="Commands"

  # rebuild path with java home
  for EACHPATH in $(cat ${JAVA_PROF}); do
    # expand vars
    EACHPATH="$(eval echo ${EACHPATH} | sed -e 's/^#.*//g;s/ *//g;')"
    [ -z ${EACHPATH} ] && continue

    if [ -d ${EACHPATH}/${BINARIES} ]; then
      # FIX:
      # must to use java bin of JRE_HOME firts
      JAVA_HOME="${EACHPATH}"
      JRE_HOME="${JAVA_HOME}/jre"
      [ -d ${JAVA_HOME} ] && PATH="${JAVA_HOME}/${BINARIES}:${U_PATH}"
      [ -d ${JRE_HOME}  ] && PATH="${JRE_HOME}/${BINARIES}:${PATH}"
      log_info "[java_setversion] - Adding new path: ${EACHPATH}/${BINARIES}"

      JAVA_VERSION=$(java -version 2>&1 | grep "version" | sed -e 's/\"//g;s/.*ion //g')
      JAVA_DESCRIPTION=$(java -version 2>&1 | grep "Environment")
      log_info "[java_setversion] - Setting JAVA HOME to ${EACHPATH}"
      log_info "[java_setversion] - Setting JAVA VERSION ${JAVA_VERSION}"
      log_info "[java_setversion] - Setting JAVA DESCRIPTION ${JAVA_DESCRIPTION}"

      # workaround hp-ux & java16
      [ ${U_LAND} = "HP-UX" ] && [ ${JAVA_ENV} = "java16" ] && SHLIB_PATH=${JRE_HOME}/lib/PA_RISC2.0/jli && log_warning "[java_setversion] - Special case, setting ${SHLIB_PATH}"
      return 0
    fi
  done

}

