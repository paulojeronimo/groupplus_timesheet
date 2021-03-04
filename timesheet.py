#!/usr/bin/env python3

import yaml
import functools
import operator
from datetime import date, datetime, timedelta

week_days = {
    'monday' : 1,
    'tuesday' : 2,
    'wednesday': 3,
    'thursday' : 4,
    'friday': 5,
    'saturday' : 6,
    'sunday': 7
}

TIME_FMT = '%H:%M'
DATE_TIME_FMT = f'%Y-%m-%d {TIME_FMT}'
toHM = lambda duration : ':'.join(str(duration).split(':')[:2])

def durations_by_time_periods(time_periods, date, cb = None):
    durations = []
    for time_period in time_periods:
        start_t = datetime.strptime(f"{date} {time_period['start_time']}", DATE_TIME_FMT)
        end_t = datetime.strptime(f"{date} {time_period['end_time']}", DATE_TIME_FMT)
        duration = end_t - start_t
        durations.append(duration)
        if cb is not None:
            cb(start_t, end_t, duration)
    return durations

with open(r'data.yaml') as file:
    data = yaml.full_load(file)
    year = data['config']['year']
    week_number = data['config']['week_number']
    timesheet = data['timesheet']
    week_total = timedelta()
    for week_day, time_periods in timesheet.items():
        date = date.fromisocalendar(year, week_number, week_days[week_day])
        print(week_day, "(", date, "):")
        day_total = functools.reduce(operator.add, durations_by_time_periods(time_periods, date,
            lambda start, end, duration: print("\t", start.strftime(TIME_FMT), "->", end.strftime(TIME_FMT), ":", toHM(duration))))
        print("\ttotal : ", toHM(day_total))
        week_total = week_total + day_total
    print("total : ", toHM(week_total))
