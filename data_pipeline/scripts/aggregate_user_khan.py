__author__ = 'zmmachar'
import csv
import sys
from operator import attrgetter

problemFile = sys.argv[1]

videoFile = sys.argv[2]

outputDir = sys.argv[3]

class eventType:
    PROBLEM = '1'
    VIDEO = '2'


print 'Loading problem data'
problemReader = csv.DictReader(open(problemFile))


print 'Loading video data'
videoReader = csv.DictReader(open(videoFile))

def compose(a, b) :
    return [a, b]




keys = ['id', 'event_type', 'timestamp', 'time_spent', 'exercise',
        'correct','problem_type', 'problem_seed', 'problem_hash',
        'hint_used', 'attempts', 'completed_video', 'video_title']

#This is so ghetto hahaha sorry
def parse_video_row(r):
    if r['videolog_backup_timestamp'] == '':
        r['videolog_backup_timestamp'] = -1

    return{
        'id': r['USER'],
        'event_type': eventType.VIDEO,
        'timestamp': int(r['videolog_backup_timestamp']),
        'time_spent': r['videolog_seconds_watched'],
        'exercise': '',
        'correct': '',
        'problem_type': '',
        'problem_seed': '',
        'problem_hash': '',
        'hint_used': '',
        'attempts': '',
        'completed_video': r['videolog_is_video_completed'],
        'video_title': r['videolog_video_title']
    }

def parse_problem_row(r):
    if r['problem_backup_timestamp'] == '':
        r['problem_backup_timestamp'] = -1
    return{
        'id': r['USER'],
        'event_type': eventType.PROBLEM,
        'timestamp': int(r['problem_backup_timestamp']),
        'time_spent': r['problem_time_taken'],
        'exercise': r['problem_exercise'],
        'correct': r['problem_correct'],
        'problem_type': r['problem_problem_type'],
        'problem_seed': r['problem_seed'],
        'problem_hash': r['problem_sha1'],
        'hint_used': r['problem_hint_used'],
        'attempts': r['attempts'],
        'completed_video': '',
        'video_title': ''
    }

def read(reader, parseFunc, userCollection):
    count = 0
    for row in reader:
        count += 1
        if count % 10000 == 0:
            print 'parsing row {}'.format(count)
        user_id = row['USER']
        if user_id not in userCollection:
            userCollection[user_id] = []
        userCollection[user_id].append(parseFunc(row))



users = {}

videoUsers = {}

print '******READING IN PROBLEMS******'
read(problemReader, parse_problem_row, users)

print '******READING IN VIDEOS******'
read(videoReader, parse_video_row, videoUsers)

for key in videoUsers.keys():
    if key in users:
        users[key].extend(videoUsers[key])

def ghettoComp(a, b):
    if a['timestamp'] < b['timestamp']:
        return -1
    else:
        return 1

print '******SAVING FILES******'
for key in users.keys():
    user = users[key]
    output = open(outputDir + 'user_'+ key, 'w')
    dict_writer = csv.DictWriter(output, keys)
    dict_writer.writer.writerow(keys)
    user.sort(ghettoComp)
    for row in user:
        row['timestamp'] = str(row['timestamp'])
    dict_writer.writerows(user)
    ##close?!!?!
