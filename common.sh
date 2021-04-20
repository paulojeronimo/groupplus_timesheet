#!/usr/bin/env bash

get-current-year() {
	date +%Y
}

get-current-month() {
	date +%m
}

get-month-name() {
	local month_number=$1

	date -d 2021-$month_number-01 +%B
}

header() {
	local month_number=$1

	echo -e "$(get-month-name $month_number) timesheet:\n"
}

get-week-number-for-today() {
	date +%V
}

get-week-number-for-date() {
	date -d $1 +%V
}

get-week-from-file-name() {
	local file_name=$1

	file_name=${file_name##*/}
	file_name=${file_name%.yaml}
	file_name=${file_name%.json}
	echo -n $file_name
}

get-last-day-of-year-month() {
	local year=$1
	local month=$2

	date -d "$(date -d $year-$month-01) +1 month -1 day" +%F
}

get-range-of-dates-for-year-month() {
	local year=$1
	local month=$2

	echo $year-$month-01 $(get-last-day-of-year-month $year $month)
}

get-year-in-data-files() {
	ls data/* | awk -F/ '{
		split($2, yw, "-");
		year = yw[1];
		printf "%d\n", year;
	}' | sort | uniq | { [ $1 = first ] && head -1 || tail -1; }
}

get-first-year-in-data-files() {
	get-year-in-data-files first
}

get-last-year-in-data-files() {
	get-year-in-data-files last
}

get-week-in-data-files() {
	local year=${1:-2021}
	local week=${2:-first}
	ls data/* | sed "s/\(data\/$year-\)\(.*\)\(.yaml\)/\2/g" | sort |
	{ [ $week = first ] && head -1 || tail -1; }
}

get-first-week-in-data-files() {
	get-week-in-data-files first
}

get-last-week-in-data-files() {
	get-week-in-data-files last
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

case "$(uname)" in
	Darwin)
		if ! type -P gdate &> /dev/null
		then
			echo "Install gdate ($ brew install gdate)!"
			exit 1
		fi
		date() { gdate "$@"; }
		;;
	Linux) :;;
	*)
		echo "Unsupported platform!"
		exit 1
esac
