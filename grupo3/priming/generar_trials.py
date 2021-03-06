#!/usr/bin/python
# -*- coding: utf-8 -*-

import numpy as np
import csv

def rotate(arr):
    return np.hstack((arr[-1], arr[0:-1]))

def rotations(palabras, group):
    rows = []

    for i in range(0,3):
        off = i * 6
        rot1 = i == group
        rot2 = i == group or i == ((group + 1) % 3)
        cond1 = "N" if rot1 else "R"
    	cond2 = "N" if rot2 else "R"

        col0 = palabras[(0+off):(6+off),0]
    	col1 = palabras[(0+off):(6+off),1]
        col2 = palabras[(0+off):(6+off),2] if not rot1 else rotate(palabras[(0+off):(6+off),1])
        col3 = palabras[(0+off):(6+off),3] if not rot2 else rotate(palabras[(0+off):(6+off),2])
        col4 = palabras[(0+off):(6+off),4]
    	col5 = np.array([cond1]*6)
    	col6 = np.array([cond2]*6)

        rows.append(np.dstack((col0, col1, col2, col3, col4, col5, col6)).reshape((6,7)))

    return np.array(rows).reshape((18,7))


palabras = []

filename = 'palabras.csv'
reader = csv.reader(open(filename))
for row in reader:
  palabras.append(row)


palabras = np.array(palabras)
print palabras.shape

warming = np.array([
    [0, "automóvil", "planeta", "sol", "v", "R", "R"], 
    [0, "motocicleta", "imaginación", "sola", "v", "R", "R"],
    [0, "tiburón", "lunar", "ladron", "v", "R", "R"],
    [0, "araña", "mira", "maldad", "v", "R", "R"]
    ])

vivos = palabras[0:18, :]
no_vivos = palabras[18:36, :]

def pp_and_save(palabras, subject_id):
    with open('palabras{}.csv'.format(subject_id), 'wb') as csvfile:
        spamwriter = csv.writer(csvfile, delimiter=',')
        for row in palabras:
            print ",".join(row)
            spamwriter.writerow(row)

trials = {}
np.random.seed(1)

for group in range(0, 3):
    trials_for_group = np.concatenate((rotations(vivos, group), rotations(no_vivos, group)))

    for subject in range(0, 5):
        subject_id = group*5 + subject
        trials_for_user = trials_for_group[:]
        np.random.shuffle(trials_for_user)
        print trials_for_user.shape
        print warming.shape
        trials_for_user = np.vstack((warming, trials_for_user))
        trials[subject_id] = trials_for_user
        print "---------------------------------"
        print "Subject:", subject_id, "----------------"
        print "---------------------------------"
        pp_and_save(trials_for_user, subject_id)
