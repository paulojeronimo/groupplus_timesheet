#!/usr/bin/env bash
set -eou pipefail
cd "`dirname "$0"`"

source ./common.sh

initial_date=${1:-$(date +%F)}
final_date=${2:-$initial_date}
begin=$(get-week-number-for-date $initial_date)
end=$(get-week-number-for-date $final_date)

#inital_year=$(get-first-year-in-data-files)
#final_year=$(get-last-year-in-data-files)
# TODO: fix this for ...
for f in $(eval echo data/2021-{$begin..$end}.yaml)
do
	[ -f $f ] || continue
	ln -sf $f data.yaml
	echo "Timesheet for week $(get-week-from-file-name $f):"
	./timesheet.py
	echo
done
