def time_to_duration: strptime("%H:%M")|[2021]+.[1:]|mktime;
def duration: (.[1]|time_to_duration)-(.[0]|time_to_duration)|strftime("%H:%M");
def total_duration: map(time_to_duration)|add|strftime("%H:%M");
