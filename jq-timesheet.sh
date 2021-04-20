#!/usr/bin/env bash
set -eou pipefail
cd "`dirname "$0"`"

source ./common.sh

initial_date=${1:-$(date +%F)}
final_date=${2:-$initial_date}
begin=$(get-week-number-for-date $initial_date)
end=$(get-week-number-for-date $final_date)

mkdir -p jsons totals/year-week
for f in $(eval echo data/2021-{$begin..$end}.yaml)
do
	[ -f $f ] || continue
	json_f=$(basename $f .yaml).json
	if ! [ -f jsons/$json_f ]
	then
		yq -j eval $f > jsons/$json_f
	else
		echo "Skipping \"$json_f\" generation ..."
	fi
	ln -sf jsons/$json_f data.json
	echo "Timesheet for week $(get-week-from-file-name $f):"
	cat <<-'EOF'
	jq 'include "timesheet"; ' data.json > totals/year-week/$json_f
	EOF
	echo
done
