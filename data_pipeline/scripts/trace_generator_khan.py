__author__ = 'zmmachar'
import sys
import csv
import operator
import numpy
from collections import deque
from os import listdir
from os.path import isfile, join
import heapq


def logTo(output, strLog):
    output.write("{}\n".format(strLog))


inputDir = sys.argv[1]
outputFile = sys.argv[2]
KCReference = sys.argv[3]
videoReference = sys.argv[4]
numPreviousVideos = int(sys.argv[5])
requiredAssociations = int(sys.argv[6])

previousVideos = deque(maxlen=numPreviousVideos)

filenames = [join(inputDir, f) for f in listdir(inputDir) if isfile(join(inputDir, f))]
out = open(outputFile + '_' + str(numPreviousVideos) + '-' + str(requiredAssociations), 'w')
exerciseId = 1
KCs = {}
reverseKCs = {}
videos = {}
reverseVideos = {}
logs = []

# user problem_name problem_hash correct
count = 0
students = {}
for f in filenames:
    video_count = 0
    problemsSinceLastVideo = {}
    previousVideos.clear()
    prevTimestamp = 0
    prevType = 0
    previousVideoName = ''
    count += 1
    studentId = f
    if count % 1000 == 0:
        print "Parsing user {}".format(count)
    csvReader = csv.reader(open(f, 'r'), delimiter=',')
    for row in csvReader:
        #problem attempt
        if row[0] == 'id':
            continue;
        timestamp = row[2]
        type = row[1]
        studentId = row[0]
        if timestamp == prevTimestamp and type != prevType:
            print 'What the hell'
        if timestamp != prevTimestamp or type != prevType:
            if type == '1':
                KC = row[4]
                if KC not in KCs:
                    KCs[KC] = {'id': exerciseId,
                               'relatedVideos': {}}
                    reverseKCs[exerciseId] = KC
                    exerciseId += 1

                KCdict = KCs[KC]
                problemType = row[6]
                problemHash = row[8]
                timeSinceLastAction = int(timestamp) - int(prevTimestamp)
                timeSpent = row[3]
                if problemType not in KCdict:
                    id = len(KCdict.keys()) - 1
                    KCdict[problemType] = {'id': id}

                problemTypeDict = KCdict[problemType]

                if problemHash not in problemTypeDict:
                    id = len(problemTypeDict.keys())
                    problemTypeDict[problemHash] = id
                correctness = 2 if row[5] == 'true' else 1

                KCid = KCdict['id']
                if KCid not in problemsSinceLastVideo:
                    problemsSinceLastVideo[KCid] = True
                    for v in previousVideos:
                        if int(timestamp) - int(v[1]) < 600000000:
                            video = videos[v[0]]
                            vId = video['id']
                            if KCdict['id'] not in video['relatedExercises']:
                                video['relatedExercises'][KCdict['id']] = 0
                            video['relatedExercises'][KCdict['id']] += 1
                            # if vId not in KCdict['relatedVideos']:
                            #     KCdict['relatedVideos'][vId] = 0
                            # KCdict['relatedVideos'][vId] += 1

                problemTypeId = problemTypeDict['id']
                problemHashId = problemTypeDict[problemHash]
                logs.append([str(studentId), str(KCid), str(problemTypeId),
                             str(problemHashId), str(correctness),
                             str(timeSinceLastAction), timeSpent])
            else:
                video_count += 1
                problemsSinceLastVideo = {}
                videoName = row[12]
                #ignore consecutive views of the same video
                if videoName != previousVideoName or prevType != type:
                    if videoName not in videos:
                        videos[videoName] = {'id': len(videos.keys()) + 1,
                                             'relatedExercises': {},
                                             'relatedKCs': [],
                                             'timesAssociated': [],
                                             'occurrences': 0}
                        reverseVideos[videos[videoName]['id']] = videoName
                    videoId = videos[videoName]['id']
                    videos[videoName]['occurrences'] += 1
                    timeSinceLastAction = int(timestamp) - int(prevTimestamp)
                    timeSpent = row[3]
                    logs.append([str(studentId), '0', str(videoId), '0', '0',
                                 str(timeSinceLastAction), timeSpent])
                    previousVideoName = videoName
                    previousVideos.append([videoName, timestamp])
            prevTimestamp = timestamp
            prevType = type
    students[str(studentId)] = video_count



        # #decorate videos with related KC IDs
        # for kc in KCs.values():
        #     if len(kc['relatedVideos'].keys()) > 0:
        #         #todo: parameterize this (takes 3 most related kcs)
        #         maxKV = heapq.nlargest(2, kc['relatedVideos'].iteritems(), key=operator.itemgetter(1))
        #         kcId = kc['id']
        #         relatedVids = [v for v in maxKV if v[1] > requiredAssociations]
        #         if len(relatedVids) > 0:
        #             for vid in relatedVids:
        #                 vId = vid[0]
        #                 numTimes = vid[1]
        #                 video = videos[reverseVideos[vId]]
        #                 video['relatedKCs'].append(kcId)
        #                 video['timesAssociated'].append(numTimes)
        #
        #

for v in videos.values():
    if len(v['relatedExercises'].keys()) > 0:
        #todo: parameterize this (takes 3 most related kcs)
        maxKV = heapq.nlargest(1, v['relatedExercises'].iteritems(), key=operator.itemgetter(1))
        relatedKCs = [KV for KV in maxKV if KV[1] > requiredAssociations]
        if len(relatedKCs) > 0:
            v['relatedKCs'] = [KC[0] for KC in relatedKCs]
            v['timesAssociated'] = [KC[1] for KC in relatedKCs]
        else:
            v['relatedKCs'] = [0]
            v['timesAssociated'] = [0]
    else:
        v['relatedKCs'] = [0]
        v['timesAssociated'] = [0]

# for v in videos.values():
#     if len(v['relatedExercises'].keys()) > 0:
#         maxKV = max(v['relatedExercises'].iteritems(),
#                              key=operator.itemgetter(1))
#         if maxKV[1] >= requiredAssociations:
#             v['relatedKC'] = maxKV[0]
#             v['timesAssociated'] = maxKV[1]
#         else:
#             v['relatedKC'] = 0
#             v['timesAssociated'] = 0
#     else:
#         v['relatedKC'] = 0
#         v['timesAssociated'] = 0




#finally, log data
# for log in logs:
#     if log[1] == '0':
#         videoId = int(log[2])
#         videoName = reverseVideos[videoId]
#         KC = videos[videoName]['relatedKC']
#         log[1] = str(KC)
#
#     logTo(out, ','.join(log))


resourceCounts = sorted(students.values())
divider = len(resourceCounts)/4
q1 = resourceCounts[divider]
q2 = resourceCounts[divider*2]
q3 = resourceCounts[divider*3]

#abusing closure
def getQuartile(studentId):
    if students[studentId] < q1:
        return '1'
    elif students[studentId] < q2:
        return '2'
    elif students[studentId] < q3:
        return '3'
    else:
        return '4'


for log in logs:
    #if a video
    # studentId = log[0]
    log[6] = getQuartile(str(log[0]))
    if log[1] == '0':
        videoId = int(log[2])
        videoName = reverseVideos[videoId]
        video = videos[videoName]
        for KC in video['relatedKCs']:
            log[1] = str(KC)
            # if log[1] in student_problems[studentId]:
            #     student_videos[studentId][log[1]] = True
            logTo(out, ','.join(log))
            ##if a student has viewed a video for this KC, log their problem attempt
            #this filters to only those students who use video content for each problem
    else:  # log[1] in student_videos[studentId] and student_videos[studentId][log[1]]:
        logTo(out, ','.join(log))
        # student_videos[studentId][log[1]] = False

reference = open(KCReference + '_' + str(numPreviousVideos) + '-' + str(requiredAssociations), 'w')

for k in KCs.keys():
    KC = KCs[k]
    logTo(reference, 'KC_' + str(KC['id']) + ':' + str(k) + ' {')
    KC.pop('id', None)
    KC.pop('relatedVideos', None)
    for t in KC.keys():
        type = KC[t]
        logTo(reference, '\ttype_' + str(type['id']) + ':' + str(t) + ' {')
        type.pop('id', None)
        for h in type.keys():
            hashId = type[h]
            logTo(reference, '\t\thash_' + str(hashId) + ':' + str(h) + ',')
        logTo(reference, '\t},')
    logTo(reference, '},')

vReference = open(videoReference + '_' + str(numPreviousVideos) + '-' + str(requiredAssociations), 'w')
reverseKCs[0] = 'None'

for v in videos.keys():
    videoId = videos[v]['id']
    relatedKCs = videos[v]['relatedKCs']
    for j in range(0, len(relatedKCs)):
        kc = relatedKCs[j]
        relatedKCName = reverseKCs[kc]
        occurrences = videos[v]['occurrences']
        timesAssociated = videos[v]['timesAssociated'][j]
        logTo(vReference, 'video_' + str(videoId) + ':' + str(v) +
              '*****Related KC: ' + str(kc) + ':' + relatedKCName)
#
# for k in KCs.keys():
#     KC = KCs[k]
#     logTo(reference, 'KC_' + str(KC['id']) + ':' + str(k) + ' {')
#     KC.pop('id', None)
#     for t in KC.keys():
#         type = KC[t]
#         logTo(reference, '\ttype_' + str(type['id']) + ':' + str(t) + ' {')
#         type.pop('id', None)
#         for h in type.keys():
#             hashId = type[h]
#             logTo(reference, '\t\thash_' + str(hashId) + ':' + str(h) + ',')
#         logTo(reference, '\t},')
#     logTo(reference, '},')
#
vReference= open(videoReference + '_' + str(numPreviousVideos) + '-' + str(requiredAssociations), 'w')
reverseKCs[0] = 'None'

for v in videos.keys():
    videoId = videos[v]['id']
    relatedKCs = videos[v]['relatedKCs']
    for j in range(0,len(relatedKCs)):
        kc = relatedKCs[j]
        relatedKCName = reverseKCs[kc]
        occurrences = videos[v]['occurrences']
        timesAssociated = videos[v]['timesAssociated'][j]
        logTo(vReference, 'video_' + str(videoId) + ':' + str(v) +
              '*****Related KC: ' + str(kc) + ':' + relatedKCName)
