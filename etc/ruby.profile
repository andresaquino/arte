# .profile
# vim: noet si ai ft=sh:

# (c) 2018, Andres Aquino <info(at)andresaquino.sh>
# This file is licensed under the BSD License version 3 or later.
# See the LICENSE file.

# TODO
# Set a ruby version
ruby_setversion ()
{
	RUBY_ENV="${1}"

	# if not exist or is empty, exit
	[ ! -d ${HOME}/paths.d ] || [ -z "$(ls -A ${HOME}/paths.d)" ] && return 0

	# rebuild path and validate
	RUBY_PROF="${HOME}/paths.d/${RUBY_ENV}"

	# ruby path file?
	grep ruby "${RUBY_PROF}" > /dev/null 2>&1 || return 0
	log_info "[ruby_setversion] - RUBY Profile ${RUBY_PROF}"

	# rebuild path with ruby home
	for EACHPATH in $(cat ${RUBY_PROF}); do
		# expand vars
		EACHPATH="$(eval echo ${EACHPATH} | sed -e 's/^#.*//g;s/ *//g;')"
		[ -z ${EACHPATH} ] && continue

		if [ -d ${EACHPATH}/${BINARIES} ]; then
			# FIX:
			# must to use ruby bin of JRE_HOME firts
			RUBY_HOME="${EACHPATH}"
			[ -d ${RUBY_HOME} ] && PATH="${RUBY_HOME}/${BINARIES}:${U_PATH}"
			log_info "[ruby_setversion] - Adding new path: ${EACHPATH}/${BINARIES}"

			RUBY_VERSION=$(ruby -version 2>&1 | grep "version" | sed -e 's/\"//g;s/.*ion //g')
			log_info "[ruby_setversion] - Setting RUBY HOME to ${EACHPATH}"
			log_info "[ruby_setversion] - Setting RUBY Version ${RUBY_VERSION}"

			return 0
		fi
	done

}

# Ruby Environment Manager
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

