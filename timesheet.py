#!/usr/bin/env python3

import yaml
import functools
from datetime import date, datetime

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

def timedelta_to_hm(timedelta):
    return timedelta.seconds // 3600, (timedelta.seconds // 60) % 60


def hm_to_str(hm):
    h, m = hm
    return f"{h:02d}:{m:02d}"


def hm_add(x, y):
    h1, m1 = x
    h2, m2 = y
    return h1 + h2, m1 + m2


def hms_by_time_periods(time_periods, date, cb = None):
    hms = []
    for time_period in time_periods:
        start_t = time_period['start_time']
        end_t = time_period['end_time']
        hm = timedelta_to_hm(datetime.strptime(f"{date} {end_t}", DATE_TIME_FMT) - datetime.strptime(f"{date} {start_t}", DATE_TIME_FMT))
        hms.append(hm)
        if cb is not None:
            cb(start_t, end_t, hm)
    return hms


with open(r'data.yaml') as file:
    data = yaml.full_load(file)
    year = data['config']['year']
    week_number = data['config']['week_number']
    timesheet = data['timesheet']
    week_total = (0, 0)
    for week_day, time_periods in timesheet.items():
        date = date.fromisocalendar(year, week_number, week_days[week_day])
        print(week_day, "(", date, "):")
        day_total = functools.reduce(hm_add, hms_by_time_periods(time_periods, date,
            lambda start_t, end_t, hm: print("\t", start_t, "->", end_t, ":", hm_to_str(hm))), (0, 0))
        print("\ttotal :", hm_to_str(day_total))
        week_total = hm_add(week_total, day_total)
    print("total :", hm_to_str(week_total))
