#!/bin/sh
# Prime Mover
#
# (C) 2006 David Given.
# Prime Mover is licensed under the MIT open source license. To get the full
# license text, run this file with the '--license' option.
#
# WARNING: this file contains hard-coded offsets --- do not edit!
#
# $Id:shell.sh 115 2008-01-13 05:59:54Z dtrg $

if [ -x "$(which arch 2>/dev/null)" ]; then
	ARCH="$(arch)"
elif [ -x "$(which machine 2>/dev/null)" ]; then
	ARCH="$(machine)"
elif [ -x "$(which uname 2>/dev/null)" ]; then
	ARCH="$(uname -m)"
else
	echo "pm: unable to determine target type, proceeding anyway"
	ARCH=unknown
fi
	
PMEXEC="./.pm-exec-$ARCH"
set -e

GZFILE=/tmp/pm-$$.gz
CFILE=/tmp/pm-$$.c
trap "rm -f $GZFILE $CFILE" EXIT

extract_section() {
	dd skip=$1 count=$2 bs=1 if="$0" 2>/dev/null | XXXEXTRACTORXXX
}

# If the bootstrap's built, run it.

if [ "$PMEXEC" -nt "$0" ]; then
	extract_section XXXXLO XXXXLS | "$PMEXEC" /dev/stdin "$@"
	exit $?
fi

# Otherwise, compile it and restart.

echo "pm: bootstrapping..."

if [ -x "$(which gcc 2>/dev/null)" ]; then
	CC="gcc -O -s"
else
	CC="cc"
fi

extract_section XXXXCO XXXXCS > /tmp/pm-$$.c
$CC $CFILE -o "$PMEXEC" && exec "$0" "$@"

echo "pm: bootstrap failed."
exit 1
