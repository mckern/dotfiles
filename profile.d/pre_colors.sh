#!/usr/bin/env bash

# disable "var is referenced but not assigned" and
# "foo appears unused. Verify it or export it" because
# these values are intended to be consumed by any other
# scripts that may change output color.
#   url: https://github.com/koalaman/shellcheck/wiki/SC2154
#   url: https://github.com/koalaman/shellcheck/wiki/SC2034
# shellcheck disable=2154,2034
: "shellcheck disable=2154,2034"

# Regular
txtblk="$(tput setaf 0 || echo '\033[0;30m')" # Black
txtred="$(tput setaf 1 || echo '\033[0;31m')" # Red
txtgrn="$(tput setaf 2 || echo '\033[0;32m')" # Green
txtylw="$(tput setaf 3 || echo '\033[0;33m')" # Yellow
txtblu="$(tput setaf 4 || echo '\033[0;34m')" # Blue
txtpur="$(tput setaf 5 || echo '\033[0;35m')" # Purple
txtcyn="$(tput setaf 6 || echo '\033[0;36m')" # Cyan
txtwht="$(tput setaf 7 || echo '\033[0;37m')" # White

# Bold
txtbld="$(tput bold || echo '\033[1m')"
bldblk="${txtblk}${txtbld}" # Black
bldred="${txtred}${txtbld}" # Red
bldgrn="${txtgrn}${txtbld}" # Green
bldylw="${txtylw}${txtbld}" # Yellow
bldblu="${txtblu}${txtbld}" # Blue
bldpur="${txtpur}${txtbld}" # Purple
bldcyn="${txtcyn}${txtbld}" # Cyan
bldwht="${txtwht}${txtbld}" # White

# Dim
txtdim="$(tput dim || echo '\033[2m')"
dimblk="${txtblk}${txtdim}" # Black
dimred="${txtred}${txtdim}" # Red
dimgrn="${txtgrn}${txtdim}" # Green
dimylw="${txtylw}${txtdim}" # Yellow
dimblu="${txtblu}${txtdim}" # Blue
dimpur="${txtpur}${txtdim}" # Purple
dimcyn="${txtcyn}${txtdim}" # Cyan
dimwht="${txtwht}${txtdim}" # White

# Italics
txtitl="$(tput sitm || echo '\033[3m')"
itlblk="${txtblk}${txtitl}" # Black
itlred="${txtred}${txtitl}" # Red
itlgrn="${txtgrn}${txtitl}" # Green
itlylw="${txtylw}${txtitl}" # Yellow
itlblu="${txtblu}${txtitl}" # Blue
itlpur="${txtpur}${txtitl}" # Purple
itlcyn="${txtcyn}${txtitl}" # Cyan
itlwht="${txtwht}${txtitl}" # White

# Underline
txtund="$(tput smul || echo '\033[4m')"
undblk="${txtblk}${txtund}" # Black
undred="${txtred}${txtund}" # Red
undgrn="${txtgrn}${txtund}" # Green
undylw="${txtylw}${txtund}" # Yellow
undblu="${txtblu}${txtund}" # Blue
undpur="${txtpur}${txtund}" # Purple
undcyn="${txtcyn}${txtund}" # Cyan
undwht="${txtwht}${txtund}" # White

# Background
bakblk="$(tput setab 0 || echo '\033[40m')" # Black
bakred="$(tput setab 1 || echo '\033[41m')" # Red
bakgrn="$(tput setab 2 || echo '\033[42m')" # Green
bakylw="$(tput setab 3 || echo '\033[43m')" # Yellow
bakblu="$(tput setab 4 || echo '\033[44m')" # Blue
bakpur="$(tput setab 5 || echo '\033[45m')" # Purple
bakcyn="$(tput setab 6 || echo '\033[46m')" # Cyan
bakwht="$(tput setab 7 || echo '\033[47m')" # White

# Reset
txtrst="$(tput sgr0 || echo '\033[0m')" # Text Reset
