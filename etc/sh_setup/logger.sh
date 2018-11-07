# (c) 2018, Andres Aquino <inbox(at)andresaquino.sh>
# This file is licensed under the BSD License version 3 or later.
# See the LICENSE file.
#
# LastModf: 20181028.2134
#

#
# log info
function _logInfo () {
  MESSAGE="${1}"
  _puts "$(date '+%Y%m-%d %H:%M:%S') ${__OSHost} DONE: ${MESSAGE}" >> ${__OSLogfile}
  _isInteractive && return 0
  ${U_DEBG} && _puts "$(_getCColor "XXX")[$(_getCColor "12X")*$(_getCColor "XXX")] ${MESSAGE}"
  return 0

}

#
# log error
function _logError () {
  MESSAGE="${1}"
  _puts "$(date '+%Y%m-%d %H:%M:%S') ${__OSHost} FAIL: ${MESSAGE}" >> ${__OSLogfile}
  ${U_DEBG} && _puts "$(_getCColor "XXX")[$(_getCColor "11X")-$(_getCColor "XXX")] ${MESSAGE}"
  return 0

}

#
# log warning
function _logWarning () {
  MESSAGE="${1}"
  _puts "$(date '+%Y%m-%d %H:%M:%S') ${__OSHost} WARN: ${MESSAGE}" >> ${__OSLogfile}
  ${U_DEBG} && _puts "$(_getCColor "XXX")[$(_getCColor "13X")!$(_getCColor "XXX")] ${MESSAGE}"
  return 0

}

#
# log some message on terminal
function _logDebug () {
  MESSAGE="${1}"
  _puts "$(date '+%Y%m-%d %H:%M:%S') ${__OSHost} MESG: ${MESSAGE}" >> ${__OSLogfile}
  ${U_DEBG} && _puts "$(_getCColor "XXX")[$(_getCColor "14X")i$(_getCColor "XXX")] ${MESSAGE}"
  return 0

}

#
# clear profile log
function _clearLogfile () {
   #
   if [[ -f "${__OSLogfile}" ]]; then
      WCOUNT="$(wc -l "${__OSLogfile}" | sed -e 's/.[a-zA-Z].*//g;s/ *//g')"
      [[ ${WCOUNT} -gt 600 ]] && echo "" > "${__OSLogfile}"
   fi
   # restore history file
   export HISTFILE=~/.history

}



