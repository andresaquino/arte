#!/bin/bash

# (c) 2017, Andres Aquino <inbox(at)andresaquino.sh>
# This file is licensed under the BSD License version 3 or later.
# See the LICENSE file.

# init terminal definition
function init_terminal () {
  # default language values
  SETCOLOR=""

  # specific setup for Linux
  if [ "${U_LAND}" = "Linux" ]; then
    # default language
    export LANGUAGE="en_US.UTF-8"
    SETCOLOR="--color=auto"

    # Release
    U_RLSE="Linux"
    if [ -f /usr/bin/lsb_release ]; then
      U_RLSE="$(/usr/bin/lsb_release -a | grep 'Description' | sed -e 's/.*:\t//; s/(.*//g; s/release //g;s/ $//g')"
    else
      # TODO
      if [ -f /etc/alpine-release ]; then
        U_RLSE="Alpine $(cat /etc/alpine-release)"
      fi

      # ej. Red Hat Enterprise Linux ES release 3 (Taroon Update 6)
      if [ -f /etc/redhat-release ]; then
        U_RLSE="$(sed -e 's/Red Hat .*Server //g; s/Enterprise //g; s/Linux //g' /etc/redhat-release )"
      fi

      U_RLSE="$(echo ${U_RLSE} | sed -e 's/.*:\t//; s/(.*//g; s/release //g;s/ $//g' | sed 's/\(.*\) \(.*\)\.\(.*\)\.\(.*\)/\1 \2.\3/g' )"

    fi

    U_NETDEVICE="enp0s eth wlan eno em"
    TPPATH=$(mktemp -q /var/tmp/.path-XXXX)
    [ $? != 0 ] && TPPATH=/var/tmp/.tppath
    TLPATH=$(mktemp -q /var/tmp/.path-XXXX)
    [ $? != 0 ] && TLPATH=/var/tmp/.tlpath

  fi

  # specific setup for OS X
  if [ "${U_LAND}" = "Darwin" ]; then
    export LANGUAGE="en_US.UTF-8"

    # Release
    U_RLSE="OS X"
    if [ -f /usr/bin/sw_vers ]; then
      U_RLSE="$(/usr/bin/sw_vers | awk '/ProductName/{print $2}') $(/usr/bin/sw_vers | awk '/ProductVersion/{print $2}' | sed  's/\(.*\)\.\(.*\)\.\(.*\)/\1.\2/g')"
    fi

    # Network
    U_NETDEVICE="en"
    TPPATH=$(mktemp -q /var/tmp/.path-XXXX)
    [ $? != 0 ] && TPPATH=/var/tmp/.tppath
    TLPATH=$(mktemp -q /var/tmp/.path-XXXX)
    [ $? != 0 ] && TLPATH=/var/tmp/.tlpath

  fi

  # set default language
  export LANG=${LANGUAGE}
  export LC_ALL=${LANGUAGE}
  export COLOR=${SETCOLOR}

  export __esc="\033["
  export __reset="${__esc}0m"

}

#
# _gC "NNN"
# getColor N,0..7
# params    : 3 chars
#             [N01234567]
#             X       - Null / No value
#             0..7    - Color ID
# X:default 0:black 1:red 2:green 3:yellow 4:blue 5:purple 6:cyan 7:white
# 0:normal 1:bold 2:dim 3:light 4:underline 5:blink 6:attrD 7:attrE
function _gC () {
   local param=${1}
   local c_string=""

   if [ ${U_TERM} = "CONSOLE" ]; then
      local c_attribute=${param:0:1}
      local c_front=${param:1:1}
      local c_back=${param:2:1}

      #
      [ "${c_attribute}" != "X" ] && c_string="${c_string}${c_attribute};"
      #
      local v_front=30
      [ "${c_front}" != "X" ] && v_front=$((${v_front}+${c_front}))
      c_string="${c_string}${v_front}"
      #
      local v_back=40
      [ "${c_back}" != "X" ] && v_back=$((${v_back}+${c_back})) && c_string="${c_string};${v_back}"
      #
      echo "${__esc}${c_string}m"
   else
      echo ""
   fi

}


#
# set environment
# load_environment
function init_environment () {
   # System binaries
   local sysbin=("/bin" "/sbin" "/usr/bin" "/usr/sbin" "/usr/sfw/bin" "/usr/xpg4/bin")
   for epath in ${sysbin}; do
      [ -d ${epath} ] && PATH=${epath}:${PATH}
   done

   # optionally, user binaries
   [ -d ${HOME}/bin ] && PATH=${HOME}/bin:${PATH}

   # first state and set time
   unset HISTFILE
   export U_DEBG=false

   # save first state of PATH, if not exists
   # .pathrc save something likes /usr/sbin:/usr/bin:/sbin:/bin
   if [ ! -f ${HOME}/.pathrc ]; then
      echo "${PATH}" > ${HOME}/.pathrc
   fi

   # Predefined profile variables
   export PATH="$(cat ${HOME}/.pathrc)"
   export U_LAND="$(uname -s)"
   export U_RLSE="SO Undefined"
   export U_SYS="$(uname -r)"
   export U_HOST="$(hostname)"
   export U_DATE="$(date '+%Y%m%d')"
   export U_HOUR="$(date '+%H%M')"
   export U_TIME="${U_DATE}${U_HOUR}"
   export U_NAME="Andres Aquino"
   export U_MAIL="inbox(at)andresaquino.sh"
   export U_WORK="AELabs!"
   export U_PATH="${PATH}"
   export U_PNET=""
   export U_NETDEVICE="eth"
   export U_IPADDRESS="127.0.0.1"
   export U_LOGFILE="${HOME}/profile.log"
   export U_FILEVERSION=""
   export U_USERID="$(id -u)"
   export U_USERNM="$(id -u -n)"
   # STAGING | PRODUCTION | DEVELOPMENT
   export U_ENVRMN="development"

   # history file and manuals
   export HISTSIZE=1500
   export HISTCONTROL=ignoredups
   export MANPATH="${HOME}/manuals:${MANPATH}"

   # Terminal settings by SO
   export HOSTNAME="$(hostname)"
   export TERM="xterm"
   export CLICOLOR=1
   export LSCOLORS="DxxxcxdxBxegedabagacad"
   export LS_COLORS="fi=00:di=01;33:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.taz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.rpm=01;31:*.jar=01;31:"

   # input mode && mask
   # TODO: set +o / -o [emacs]
   set +o emacs
   set -o vi
   umask 077

   # init terminal
   init_terminal

   # get version in a dynamic style using unix.profile
   U_FILEVERSION="0000000"
   if [ -f /usr/local/unix.profile ]; then
      U_FILEVERSION="$(openssl dgst -md5 /usr/local/unix.profile | awk '{ print substr($0,length()-6,7); }')"
   fi

   # set local paths
   set_local_paths

}

#
# Get IP Address
function get_ipaddress () {
   # try first principal interface
   if [ -n "${U_PNET}" ]; then
      ADDRESS="$(ifconfig ${U_PNET} 2> /dev/null| awk '/inet [addr:]*/ {print $2}' | sed -e 's/.*://g')"
      DEV=${U_PNET}
   fi

   # and if last test failed
   if [ -z ${ADDRESS} ]; then
      # .. and for each device, test and found active interface
      for EACHNDEV in ${U_NETDEVICE}; do
         for NDEV in 4 3 2 1 0; do
            DEV="${EACHNDEV}${NDEV}"
            ADDRESS="$(ifconfig ${DEV} 2> /dev/null| awk '/inet [addr:]*/ {print $2}' | sed -e 's/.*://g')"
            log_message "[get_ipaddress] - Looking for ${DEV}:${ADDRESS}"
            [ -n "${ADDRESS}" ] && break
         done
         U_NETDEVICE=${DEV}
         [ -n "${ADDRESS}" ] && break
      done
   fi

   [ -z ${ADDRESS} ] && ADDRESS="127.0.0.1"
   U_IPADDRESS=${ADDRESS}
   log_message "[get_ipaddress] - Getting interface ${DEV}:${ADDRESS}"

   # and finally, set environment
   # STAGING | PRODUCTION | DEVELOPMENT
   if [ -z ${U_ENVRMN} ]; then
      U_ENVRMN="development"
   fi

   # to lowercase, bash < 4.0
   U_ENVRMN=$(tr [A-Z] [a-z] <<< ${U_ENVRMN})
   case ${U_ENVRMN} in
      "staging")
         U_ENVRMN="E2E"
         ;;
      "certification")
         U_ENVRMN="UAT"
         ;;
      "production")
         U_ENVRMN="PRD"
         ;;
      *)
         U_ENVRMN="DEV"
         ;;
   esac
   U_ENVCOLOR="$(_fC "13X")${U_ENVRMN}${__reset}"

}



#
# Prints a message
function puts () {
  # empty message?
  [[ -z ${1} ]] && return 0

  # let's go
  LMESSAGE="${1}"

  case "${U_LAND}" in
    "Linux"|"Darwin"|"SunOS")
      echo -e -n "${LMESSAGE} \n"
      ;;

    *)
      echo "${LMESSAGE} "
      ;;
  esac

}


#
# load especific variables from a file
function load_profile () {
  U_PROFILE=${1}
  if [ -s ${U_PROFILE} ]; then
    . ${U_PROFILE} > /dev/null 2>&1
    U_PROFILE="$(basename ${U_PROFILE})"
    log_info "[load_profile] - Loading profile ${U_PROFILE}"
  fi

}

#
# Validate freshness of a single file
function has_changes () {
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
# Define a execution unix path reading each file in Paths.d
function set_local_paths () {
   # System binaries
   local LPATH=
   local sysbin=("/bin" "/sbin" "/usr/bin" "/usr/sbin" "/usr/sfw/bin" "/usr/xpg4/bin")
   for epath in ${sysbin}; do
      [ -d ${epath} ] && PATH=${epath}:${PATH}
   done

   # optionally, user binaries
   [ -d ${HOME}/bin ] && LPATH=${HOME}/bin:${LPATH}

   # if not exist or is empty, exit
   if [ ! -d ${HOME}/paths.d ]; then
      log_error "[set_local_paths] - , we dont have a paths.d directory"
      return 0
   fi

   # load cache path
   get_current_time
   DPATH=${HOME}/paths.d/${U_HOST}-${U_EDATE}.path
   HAVE_CHANGES="no"
   log_info "[set_local_paths] - loading ${DPATH} paths"

   if [ -f ${DPATH} ]; then
      # so, can we verify the freshness?
      #log_info "[set_local_paths] - ok, time to search changes on config files (paths.d)"
      for PATHFILE in ${HOME}/paths.d/[0-9][0-9].*; do
         [ ${PATHFILE} -nt ${DPATH} ] && log_info "[set_local_paths] - Changes on ${PATHFILE}" && HAVE_CHANGES="yes"
      done
   else
      HAVE_CHANGES="yes"
   fi

   if [ ${HAVE_CHANGES} = "no" ]; then
      LPATH="$(cat ${DPATH})"
      BASENAME="$(basename ${DPATH})"
      log_info "[set_local_paths] - fast upload path from ${BASENAME}"
   else
      # lock for any file with path as contents
      log_info "[set_local_paths] - building path environment"
      for PATHFILE in ${HOME}/paths.d/[0-9][0-9].*; do
         BASENAME="$(basename ${PATHFILE})"
         # empty file
         [ ! -s ${PATHFILE} ] && log_error "[set_local_paths] - Empty file ${PATHFILE}" && continue
         # not include java paths
         grep java ${PATHFILE} > /dev/null 2>&1 && continue
         DIRS=0
         # for each file, get paths and add to execution path
         while read EACHPATH; do
            IS_USEFUL="yes"
            LOCALPATH="$(echo ${EACHPATH} | sed -e 's/^#.*//g;s/ *//g;')"
            [ -z "${LOCALPATH}" ] && IS_USEFUL="no" && continue
            # get one line (path) and eval, eval vars like ${HOME} or ${PATH}
            LOCALPATH="$(eval echo ${LOCALPATH})"
            # is this a directory?
            [ ! -d ${LOCALPATH} ] && IS_USEFUL="no"
            if [ "${IS_USEFUL}" = "yes" ]; then
               LPATH="${LOCALPATH}:${LPATH}"
               DIRS=$((${DIRS}+1))
            fi
         done < ${PATHFILE}
         [ ${DIRS} -gt 0 ] && log_info "[set_local_paths] - Loading paths ${BASENAME}"
      done
      # save temporal path
      rm -f ${HOME}/paths.d/*.path
      echo "${LPATH}" > ${DPATH} 2>/dev/null
      log_info "[set_local_paths] - Savving ${LPATH} => ${DPATH}"
   fi

   # filter before to set ..
   LPATH="$(echo "${LPATH}:${U_PATH}" | sed -e 's/::/:/g')"

   # .. and organize
   touch ${TPPATH}
   IPATH=$(echo ${LPATH} | awk -F':' '{for(i=1; i<=NF; i++) print $i }')
   for EACHPATH in ${IPATH}; do
      grep -q -x "${EACHPATH}" ${TPPATH}
      [ $? -eq 0 ] && continue
      [ -z ${EACHPATH} ] && continue
      echo ${EACHPATH} >> ${TPPATH}
   done

   # delete double(:) and (.) local search of executables
   LPATH="$(awk 'BEGIN{PPATH=""} {PPATH=PPATH":"$0} END{print PPATH}' ${TPPATH} | sed -e 's/\.::*//g;s/^::*//g;s/::*/:/g')"
   rm ${TPPATH} > /dev/null 2>&1

   # maintenance routine
   find /var/tmp -type f -name '.path*' -mtime +1 -user ${U_USERNM} -exec rm -f {} \; > /dev/null 2>&1
   log_error "[set_local_paths] - Maintenance of tmp files"

   # security's issue, depends of you.. PATH=".:${LPATH}"
   if [ ${U_USERID} -ne 0 ]; then
      export PATH=".:${LPATH}"
   else
      export PATH="${LPATH}"
   fi

   # try to preserve as an initial path of user environment
   U_PATH=${PATH}

}


#
# Get Current Time
function get_current_time () {
  # one call, please
  U_DATE="$(date '+%Y%m%d')"
  U_EDATE="$(date '+%Y%m-%d')"
  U_HOUR="$(date '+%H%M')"
  U_EHOUR="$(date '+%H:%M:%S')"
  U_TIME="${U_DATE}${U_HOUR}"
  U_ETIME="${U_EDATE} ${U_EHOUR}"

}

function get_path () {
  lpath=$(pwd)
  if [ ${#lpath} -gt 40 ]; then
    echo "..${lpath: -40}"
  else
    echo "${lpath}"
  fi
}

# time
function get_timestamp () {
  echo "$(date '+%Y%m/%d %H:%M:%S')"
}

# time
function get_minimal_timestamp () {
  echo "$(date '+%Y%m%d·%H%Mµ%S')"
}

#
# log DONE tasks
function log_info () {
  MESSAGE="${1}"
  puts "$(date '+%Y%m-%d %H:%M:%S') ${U_HOST} DONE: ${MESSAGE}" >> ${U_LOGFILE}
  [ "${U_TERM}" != "CONSOLE" ] && return 0
  ${U_DEBG} && puts "${__reset}[$(_gC "12X")*${__reset}] ${MESSAGE}"
  return 0

}


#
# log ERROR tasks
function log_error () {
  MESSAGE="${1}"
  puts "$(date '+%Y%m-%d %H:%M:%S') ${U_HOST} FAIL: ${MESSAGE}" >> ${U_LOGFILE}
  ${U_DEBG} && puts "${__reset}[$(_gC "11X")-${__reset}] ${MESSAGE}"
  return 0

}


#
# log WARNING tasks
function log_warning () {
  MESSAGE="${1}"
  puts "$(date '+%Y%m-%d %H:%M:%S') ${U_HOST} WARN: ${MESSAGE}" >> ${U_LOGFILE}
  ${U_DEBG} && puts "${__reset}[$(_gC "13X")!${__reset}] ${MESSAGE}"
  return 0

}


#
# log some message on terminal
function log_message () {
  MESSAGE="${1}"
  puts "$(date '+%Y%m-%d %H:%M:%S') ${U_HOST} MESG: ${MESSAGE}" >> ${U_LOGFILE}
  ${U_DEBG} && puts "${__reset}[$(_gC "14X")i${__reset}] ${MESSAGE}"
  return 0

}

# puts some message on terminal
function message () {
  # empty message?
  [[ -z ${1} ]] && return 0
  puts "$(_gc "03X")> ${__reset}${1}"

}


#
# waiting process indicator
function wait_for () {
  STRWAIT="-\|/-"
  STRLENT=$((${#STRWAIT}-1))
  CHRWAIT="-"
  MESSAGE=${1}

  if [ ${U_TERM} = "CONSOLE" ]; then
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
        if [ "${U_LAND}" = "HP-UX" ]; then
          TPOS=$((${CPOS} + 1))
          CHRWAIT=$(expr substr ${STRWAIT} ${TPOS} 1)
        else
          CHRWAIT=${STRWAIT:${CPOS}:1}
        fi
        puts "${__reset}[$(_gC "03X") ${CHRWAIT} ${__reset}] ${MESSAGE}"
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



#
# Shows MD5 of this profile
function show_version () {
  puts "Ver.${U_FILEVERSION} (${U_LAND}) \nunix/shell profile \n\nDeveloped by \nAndres Aquino <inbox(at)andresaquino.sh>"
}

#
# reling profile properties
function relink_profile () {
  cd ${HOME}
  if [ -f .profile ]; then
    mv .profile profile.${U_DATE}
    ln -sf ${HOME}/shell.profile ${HOME}/.profile
    log_info "[relink_profile] - $(_gC "17X")links updated...${__reset}"
    chmod 0700 ${HOME}/.ssh
    chmod 0600 ${HOME}/shell.profile ${HOME}/unix.profile ${HOME}/.ssh/authorized*
    log_info "[relink_profile] - Setting permissions to *.profile"
  fi

  if [ ! -z "${BASH_VERSION}" ]; then
    mv .bashrc bashrc.${U_DATE}
    mv .bash_profile bash_profile.${U_DATE}
    ln -sf ${HOME}/shell.profile ${HOME}/.bashrc
    ln -sf ${HOME}/shell.profile ${HOME}/.bash_profile
    log_info "[relink_profile] - $(_gC "17X")links updated...${__reset}"
  fi

}


#
# clear profile log
function clear_profile () {
  if [ -f ${U_LOGFILE} ]; then
    WCOUNT="$(wc -l ${U_LOGFILE} | sed -e "s/.[a-zA-Z].*//g;s/ *//g")"
    [ ${WCOUNT} -gt 600 ] && echo "" > ${U_LOGFILE}
  fi
  # restore history file
  export HISTFILE=~/.history

}

#
# Shows Information about this system
function show_internals () {
  get_current_time
  message "System Operating : ${U_LAND}"
  message "Host Name        : ${U_HOST}"
  message "Version profile  : ${U_FILEVERSION}"
  message "Unix profile     : /usr/local/unix.profile"
  message "Shell profile    : /usr/local/shell.profile"
  message "Current date     : ${U_DATE}"
  message "Current hour     : ${U_HOUR}"
  message "IP Address       : ${U_IPADDRESS}"
  message "Current PATH     : ${PATH}"

}

#
# UAT | 192.168.100.9 | Mac 10.12 | 07/12 12:15:09 /Users/andresaquino
# «master» andresaquino(@)macuarrita $>
function set_full_cmdline () {
  # additional esc sequences
  EI="\["
  EO="\]"

  # set PS1
  if [ "${U_LAND}" = "HP-UX" ]; then
    export PS1="$(echo "\n${__reset}[ $(_gC "03X")${U_ENVRMN} $(_gC "14X")${U_IPADDRESS}${__reset} @ ${U_HOST} / $(_gC "13X")${U_RLSE}${__reset} ] \${PWD} \n${__reset}${USER} \$ ")"
  else
    # if you're a developer, set your git profile (yes...)
    if [ -r /usr/local/arte/etc/${U_GIT_PROFILE} ]; then
      PS_1="\n${__reset}${U_ENVCOLOR} > $(_gC "03X")${U_IPADDRESS}${__reset} "
      PS_1="${PS_1}> $(_gC "03X")${U_RLSE}${__reset} "
      PS_1="${PS_1}\$(get_timestamp) > \$(get_path) \n$(_gC "12X")\$(__git_ps1 '«%s» ')${__reset}"
      PS_1="${PS_1}${USER}$(_gC "04X")(@)${__reset}${U_HOST} $(_gC "03X")\\$>${__reset} "

    else
      PS_1="\n${__reset}${U_ENVCOLOR} > $(_gC "03X")${U_IPADDRESS}${__reset} "
      PS_1="${PS_1}> $(_gC "03X")${U_RLSE}${__reset} "
      PS_1="${PS_1}\$(get_timestamp) > \$(get_path) \n${__reset}"
      PS_1="${PS_1}${USER}$(_gC "04X")(@)${__reset}${U_HOST} $(_gC "03X")\\$>${__reset} "

    fi
  fi
  export PS1="${PS_1}"
  export PS2=" ..> "
  unset USERNAME

}

#
# macuarrita:192.168.100.9 ..no/projects/bcapp.git/containers/mariadb
# «master» ~ andresaquino $>
function set_normal_cmdline () {
  # additional esc sequences
  EI="\["
  EO="\]"

  # set PS1
  if [ "${U_LAND}" = "HP-UX" ]; then
    export PS1="$(echo "\n${__reset}[ $(_gC "03X")${U_ENVRMN} $(_gC "14X")${U_IPADDRESS}${__reset} @ ${U_HOST} / $(_gC "13X")${U_RLSE}${__reset} ] \${PWD} \n${__reset}${USER} \$ ")"
  else
    # if you're a developer, set your git profile (yes...)
    if [ -r /usr/local/arte/etc/${U_GIT_PROFILE} ]; then
      PS_1="\n${__reset}${U_HOST}>$(_gC "03X")${U_IPADDRESS}"
      PS_1="${PS_1}${__reset}>\$(get_minimal_timestamp)>\$(get_path) "
      PS_1="${PS_1}\n$(_gC "03X")${U_RLSE} $(_gC "12X") "
      PS_1="${PS_1}\$(__git_ps1 '«%s» ')$(_gC "04X")@${USER} $(_gC "03X")\\$>${__reset} "

    else
      PS_1="\n${__reset}${U_HOST}>$(_gC "03X")${U_IPADDRESS}"
      PS_1="${PS_1}${__reset}>\$(get_minimal_timestamp)>\$(get_path) "
      PS_1="${PS_1}\n$(_gC "03X")${U_RLSE}$(_gC "04X")@${USER} $(_gC "03X")\\$>${__reset} "

    fi
  fi

  export PS1="${PS_1}"
  export PS2=" ..> "
  unset USERNAME

}

#
# 192.168.100.9: mariadb
# «master» (@)macuarrita $>
function set_minimal_cmdline () {
  # additional esc sequences
  EI="\["
  EO="\]"

  # set PS1
  if [ "${U_LAND}" = "HP-UX" ]; then
    export PS1="$(echo "\n${__reset}[ $(_gC "03X")${U_ENVRMN} $(_gC "14X")${U_IPADDRESS}${__reset} @ ${U_HOST} / $(_gC "13X")${U_RLSE}${__reset} ] \${PWD} \n${__reset}${USER} \$ ")"
  else
    # if you're a developer, set your git profile (yes...)
    if [ -r /usr/local/arte/etc/${U_GIT_PROFILE} ]; then
      PS_1="\n${__reset}[${U_HOST}]:"
      PS_1="${PS_1}$(_gC "03X")\$(get_path) \n"
      PS_1="${PS_1}$(_gC "14X")\$(get_minimal_timestamp) "
      PS_1="${PS_1}$(_gC "11X")\$(__git_ps1 '«%s» ')"
      PS_1="${PS_1}${__reset}@${USER} $(_gC "03X")\\$> ${__reset}"

    else
      PS_1="\n${__reset}[${U_HOST}]:"
      PS_1="${PS_1}$(_gC "03X")\$(get_path) \n"
      PS_1="${PS_1}$(_gC "14X")\$(get_minimal_timestamp)"
      PS_1="${PS_1}${__reset}@${USER} $(_gC "03X")\\$> ${__reset}"

    fi
  fi
  export PS1="${PS_1}"
  export PS2=" ..> "
  unset USERNAME


}


#
# main
if [ -z "${U_LAND}" ]; then
  # if you want to use in scripts
  export U_TERM="TERM"
  TTYTERM=${HOME}/.sttytemp
  stty 2> /dev/null 1> ${TTYTERM}
  if [ -s ${TTYTERM} ]; then
    rm ${TTYTERM} > /dev/null 2>&1
    export U_TERM="CONSOLE"

  else

    # load environment
    init_environment

    # and server profile
    clear_profile

    # load git developer profile
    load_profile "/usr/local/arte/etc/git.profile"

    # load java developer profile
    load_profile "/usr/local/arte/etc/java.profile"

    # load java developer profile
    load_profile "/usr/local/arte/etc/ruby.profile"

    # load java developer profile
    load_profile "/usr/local/arte/etc/ssh.profile"

    # load per host profile
    load_profile "${HOME}/${U_HOST}.profile"

  fi

fi

