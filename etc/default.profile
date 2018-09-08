# .profile
# vim: noet si ai syn=sh: 

# (c) 2018, Andres Aquino <inbox(at)andresaquino.sh>
# This file is licensed under the BSD License version 3 or later. 
# See the LICENSE file.

#
# Use this file to define a generic profile

# ID
export U_NAME="User Name"
export U_MAIL="username@email.net"
export U_WORK="AELabs!"
export U_PNET="en0"

# ssh-agent: no
export SSH_AGENT=

# editor
export EDITOR=vim

# when manipulate services (RedHat or alike)
export SYSTEMD_PAGER=

# when search params
export GREP_OPTIONS='--color=auto'

# JAVAHome
export JAVA_HOME=""

# Others:
# Use GitHUB?
#export HOMEBREW_GITHUB_API_TOKEN=""

# Use docker-machine?
#docker-machine env
#export MACHINE_STORAGE_PATH=/VirtualBox/machine
#eval $(docker-machine env default)

# Use tmux?
# TTY Size
#export TTYROWS=$(stty size | cut -f1 -d' ')
#export TTYCOLS=$(stty size | cut -f2 -d' ')

