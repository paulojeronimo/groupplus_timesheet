#!/usr/bin/env bash
set -eou pipefail
cd "`dirname "$0"`"
source ./common.sh

year=${1:-$(get-current-year)}
month=${2:-$(get-current-month)}
[[ $month =~ ^0 ]] || month=0$month
output_dir=totals/year-month

mkdir -p $output_dir
timesheet=`mktemp`
{
	header $month
	./timesheet.sh $(get-range-of-dates-for-year-month $year $month) > $timesheet
	cat $timesheet
	totalize
} | tee $output_dir/$year-$month.txt
