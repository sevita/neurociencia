import numpy as np
import random
import csv

def unicode_csv_reader(utf8_data, dialect=csv.excel, **kwargs):
    csv_reader = csv.reader(utf8_data, dialect=dialect, **kwargs)
    for row in csv_reader:
        yield [unicode(cell, 'utf-8') for cell in row]

def rotate(arr):
    return np.hstack((arr[-1], arr[0:-1]))

def rotations(palabras, group):
    rows = []
    for i in range(0,3):
        off = i * 6
        rot1 = i == group
        rot2 = i == group or i == ((group + 1) % 3)
        print "grupo:", group, "cond:", rot1, rot2
        col0 = palabras[(0+off):(6+off),0]
        col1 = palabras[(0+off):(6+off),1] if not rot1 else rotate(palabras[(0+off):(6+off),1])
        col2 = palabras[(0+off):(6+off),2] if not rot2 else rotate(palabras[(0+off):(6+off),2])
        col3 = palabras[(0+off):(6+off),3]

        rows.append(np.dstack((col0, col1, col2, col3)).reshape((6,4)))
    
    return np.array(rows).reshape((18,4))
    

palabras = []

# filename = 'palabras.csv'
# reader = unicode_csv_reader(open(filename))
# for row in reader:
#   palabras.append(row)
#

#
# palabras = np.array(palabras)
# print palabras.shape

palabras = np.arange(36*4).reshape((36,4))

vivos = palabras[0:18, :]
no_vivos = palabras[18:36, :]

trials = {}
for group in range(0, 3):
    trials_for_group = np.concatenate((rotations(vivos, group), rotations(no_vivos, group)))
    print "group: ", group, "trials:", trials_for_group.shape, '\n', trials_for_group

    for subject in range(0, 5):
        trials_for_user = trials_for_group[:]
        random.shuffle(trials_for_user)
        trials[subject + group] = trials_for_user
