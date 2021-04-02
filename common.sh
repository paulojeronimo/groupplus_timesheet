#!/usr/bin/env bash

header() {
	local month=$1

	echo -e "$month timesheet:\n"
}

totalize() {
	echo    '-----------------------'
	echo -n 'Total of hours: '
	cat $timesheet | awk -F' : ' '/^total/ {print $2}' |
	awk '{
			split($1, tm, ":");
			mins += tm[2];
			hrs += tm[1] + int(mins / 60);
			mins %= 60
		}
		END {
			printf "%02d:%02d\n", hrs, mins;
		}'
}
