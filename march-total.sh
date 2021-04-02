#!/usr/bin/env bash
cd "`dirname "$0"`"
source ./common.sh

timesheet=`mktemp`
{
	header March

	./timesheet.sh 09 13 > $timesheet
	cat $timesheet

	totalize
} | tee `basename $0 .sh`.txt
