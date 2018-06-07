# .profile
# vim: si ai ft=sh:

# (c) 2018, Andres Aquino <info(at)andresaquino.sh>
# This file is licensed under the BSD License version 3 or later.
# See the LICENSE file.

#
# SSH profile
export SSH_PID=
export SSH_AGENT=

ssh_setagent() {

  if [[ ${SSH_AGENT} ]]; then
    # get ppid
    SSH_PID=$(/bin/ps -x -o pid,user,uid,args | grep -E " ${U_USERID} [s]sh-agent" | awk '{print $1}')
    
    # if ssh-agent master process does not exist
    if [[ -z "${SSH_PID}" ]]; then
      # start a new process
      /usr/bin/ssh-agent | grep -E "[S]SH_" > ${HOME}/sshagent.profile
      log_info "Loading a new ssh-agent instance"
    fi
  fi

  # exists a sshagent profile ?
  if [[ -r ${HOME}/sshagent.profile ]]; then
    # use it
    . ${HOME}/sshagent.profile
    log_info "Loading a ssh instance ${SSH_AGENT_PID}"
  fi

}

