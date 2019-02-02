#!/bin/sh
### BEGIN INIT INFO
# Provides:          functions.sh
# Required-Start:
# Required-Stop:
# Short-Description: Replicates Gentoo's functions.sh
# Description:       Replicates Gentoo's functions.sh in a portable way.
#                    Obviously borrow heavily from the original rc script
#                    written by Roy Marples
### END INIT INFO

# Copyright (c) 2015 Marcus Downing <marcus.downing@gmail.com>
# Released under the 2-clause BSD license.

eindent() {
  . "$EFUNCTIONS_DIR/eindent"
}

eoutdent() {
  . "$EFUNCTIONS_DIR/eoutdent"
}

ostype() {
	osname=$(uname -s)
	# Assume we do not know what this is
	OSTYPE=UNKNOWN
	case $osname in
		"FreeBSD") OSTYPE="FREEBSD"
	;;
		"SunOS") OSTYPE="SOLARIS"
	;;
		"Linux") OSTYPE="LINUX"
	;;
	esac
	return 0
}

evenodd() {
	#determine odd/even status by last digit
	LAST_DIGIT=$(echo $1 | sed 's/\(.*\)\(.\)$/\2/')
	case $LAST_DIGIT in
		0|2|4|6|8 )
			return 1
		;;
		* )
			return 0
		;;
	esac
}

setupenv() {
	if [ "$OSTYPE" = ""]; then
		ostype
	fi
	NAME=$(uname -n)
	case $OSTYPE in
		"LINUX" )
			PING=/usr/sbin/ping
		;;
		"FREEBSD" )
			PING=/sbin/ping
		;;
		"SOLARIS" )
			PING=/usr/sbin/ping
		;;
		*)
		;;
	esac
}

isalive() {
	NODE="$1"
	$PING -c 3 $NODE >/dev/null 2>&1
	if [ $? -eq 0 ]; then
		return 1
	else
		return 0
	fi
}

# http://stackoverflow.com/questions/1055671/how-can-i-get-the-behavior-of-gnus-readlink-f-on-a-mac
abspath() {
  if readlink -f "$1" 2>&1 | grep -q 'readlink: illegal option -- f'; then
    TARGET_FILE="$1"

    cd `dirname "$TARGET_FILE"`

    TARGET_FILE=`basename "$TARGET_FILE"`

    # Iterate down a (possible) chain of symlinks
    while [ -L "$TARGET_FILE" ]
    do
      TARGET_FILE="`readlink "$TARGET_FILE"`"
      cd "`dirname "$TARGET_FILE"`"
      TARGET_FILE="`basename "$TARGET_FILE"`"
    done

    # Compute the canonicalized name by finding the physical path
    # for the directory we're in and appending the target file.
    PHYS_DIR="`pwd -P`"
    RESULT="$PHYS_DIR/$TARGET_FILE"
  else
    RESULT="$(readlink -f "$1")"
  fi

  echo $RESULT
}

if [ -x "/etc/init.d/functions.sh" ]; then
  HERE="$(abspath "/etc/init.d/functions.sh")"
else
  HERE="$(abspath "$0")"
fi
DIR="$(dirname "$HERE")"
export EFUNCTIONS_DIR="$DIR/efunctions"
export PATH="$PATH:$EFUNCTIONS_DIR"

if [ -n "$TERM" ] && [ "$TERM" = unknown ] ; then
  export TERM=dumb
fi

if [ -z "$TERMINFO" ]; then
  export TERMINFO=$(whereis terminfo | grep -o '^[^ ]* [^ ]*' | grep -o '[^ ]*$')
fi

export EFUNCTIONS_ECHO="$(which echo)"
if [ "yes" != "$EFUNCTIONS_LOADED" ]; then
	export EINFO_INDENT=0
fi
export EFUNCTIONS_LOADED="yes"
