#!/usr/bin/env bash
cd "`dirname "$0"`"
source ./common.sh

timesheet=`mktemp`
{
	header February

	./timesheet.sh 07 08 > $timesheet
	cat $timesheet

	totalize
} | tee `basename $0 .sh`.txt
