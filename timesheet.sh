#!/usr/bin/env bash
set -eou pipefail

for f in data/*.yaml
do
	ln -sf $f data.yaml
	echo "Timesheet for file \"$f\":"
	./timesheet.py
	echo
done
