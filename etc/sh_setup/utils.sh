# (c) 2018, Andres Aquino <inbox(at)andresaquino.sh>
# This file is licensed under the BSD License version 3 or later.
# See the LICENSE file.
#
# LastModf: 20181028.2134
#

#
# Validate freshness of a single file
function has_changes() {
  SFILE=${1}

  # md5 calculate per each file (fast load)
  [ ! -f "${SFILE}.md5" ] && openssl dgst -md5 "${SFILE}" > "${SFILE}.md5"
  MD5DIGEST="$(openssl dgst -md5 ${SFILE} | sed -e "s/.*= //g")"
  MD5BACKUP="$(cat ${SFILE}.md5 | sed -e "s/.*= //g")"

  # has changes?
  if [ "${MD5DIGEST}" = "${MD5BACKUP}" ]; then
    return 1
  else
    return 0
  fi


}


#
# reling profile properties
function relink_profile () {
  cd ${HOME}
  if [ -f .profile ]; then
    mv .profile profile.${U_DATE}
    ln -sf ${HOME}/shell.profile ${HOME}/.profile
    log_info "[relink_profile] - $(_getCColor "17X")links updated...$(_getCColor "XXX")"
    chmod 0700 ${HOME}/.ssh
    chmod 0600 ${HOME}/shell.profile ${HOME}/unix.profile ${HOME}/.ssh/authorized*
    log_info "[relink_profile] - Setting permissions to *.profile"
  fi

  if [ ! -z "${BASH_VERSION}" ]; then
    mv .bashrc bashrc.${U_DATE}
    mv .bash_profile bash_profile.${U_DATE}
    ln -sf ${HOME}/shell.profile ${HOME}/.bashrc
    ln -sf ${HOME}/shell.profile ${HOME}/.bash_profile
    log_info "[relink_profile] - $(_getCColor "17X")links updated...$(_getCColor "XXX")"
  fi

}


# puts some message on terminal
function message () {
  # empty message?
  [[ -z ${1} ]] && return 0
  _puts "$(_getCColor "03X")> $(_getCColor "XXX")${1}"

}

#
# waiting process indicator
function wait_for () {
  STRWAIT="-\|/-"
  STRLENT=$((${#STRWAIT}-1))
  CHRWAIT="-"
  MESSAGE=${1}

  if _isInteractive; then
    if [ "${MESSAGE}" != "CLEAR" ]; then
      TIMEWAIT=$((1*${#STRWAIT}))
      message "${MESSAGE}"
      tput init
      tput sc
      tput civis
      CPOS=0
      while true; do
        tput rc
        tput cuu1
        tput ll
        if is_hpux; then
          TPOS=$((${CPOS} + 1))
          CHRWAIT=$(expr substr ${STRWAIT} ${TPOS} 1)
        else
          CHRWAIT=${STRWAIT:${CPOS}:1}
        fi
        _puts "$(_getCColor "XXX")[$(_getCColor "03X") ${CHRWAIT} $(_getCColor "XXX")] ${MESSAGE}"
        [ ${CPOS} -eq ${STRLENT} ] && CPOS=0 || CPOS=$((${CPOS} + 1))
        perl -e 'select(undef,undef,undef,.1)'
        [ ${TIMEWAIT} -eq 0 ] && break || TIMEWAIT=$((${TIMEWAIT}-1))
      done
    else
      tput rc
      tput cuu1
      tput ll
      tput cnorm
      tput el
    fi
    tput rc
    tput cuu1
    tput ll
    tput cnorm
    tput el
  else
    message "${MESSAGE}"
    while true; do
      perl -e 'select(undef,undef,undef,.1)'
      TIMEWAIT=$((${TIMEWAIT}-1))
      [ ${TIMEWAIT} -eq 0 ] && break
    done
  fi

}




