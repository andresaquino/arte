#!/bin/bash
# vim: noet si ai ft=sh:

# (c) 2018, Andres Aquino <inbox(at)andresaquino.sh>
# This file is licensed under the BSD License version 3 or later.
# See the LICENSE file.

# set environment
if [[ -f /usr/local/unix.profile ]]
then
	# load environment
	. /usr/local/unix.profile

	if [[ ${U_TERM} = "CONSOLE" ]]
	then
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

		# load per host ssh profile
		load_profile "/usr/local/arte/etc/ssh.profile"

		# load per host profile
		load_profile "${HOME}/default.profile"

		# load per host profile
		load_profile "${HOME}/${U_HOST}.profile"

		# get IP Address
		get_ipaddress

		# everybody loves logos, try one with figlets ;)
		if [[ -r /usr/local/logo.info ]]; then
			clear
			cat /usr/local/logo.info
			puts "-"
		else
			puts " "
			message "${U_HOST}"
		fi

		# common alias
		alias ls="ls -F ${COLOR}"
		alias ll="ls -l"
		alias la="ll -a"
		alias lt="la -t"
		alias lr="lt -r"
		alias pw="pwd"
		alias defn="${FUNCTIONS}"

		# set input command style
		set_minimal_cmdline

		# set ssh agent
		ssh_setagent

		# yeahh!
		message "Ver. ${U_FILEVERSION}, this is a ${U_LAND}/${U_RLSE}"
		message "${U_ETIME}"
		message "Welcome!"

	fi

fi

