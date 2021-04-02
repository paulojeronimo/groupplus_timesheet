#!/usr/bin/env bash
set -eou pipefail
cd `dirname $0`

begin=${1:-09}
end=${2:-13}
files=$(eval echo data/2021-{$begin..$end}.yaml)

for f in $files
do
	ln -sf $f data.yaml
	echo "Timesheet for file \"$f\":"
	./timesheet.py
	echo
done
