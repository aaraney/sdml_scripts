#!/usr/bin/env python
# -*- coding: utf-8 -*-

# author: Austin Raney Nov 27 2018

import csv, sys

# returns the index of the nth occurance of a
# string or character within a string
def findnth(string, substring, n):
    parts = string.split(substring, n + 1)
    if len(parts) <= n + 1: 
    	return -1 
    return len(string) - len(parts[-1]) - len(substring)

# Paths and Args
RG = sys.argv[1]
F_PATH = sys.argv[2]

def date_formatter():
	# date formater function
	# this function was designed to be implimeted using a
	# redirect in bash i.e. python date_formater.py a.file > b.file
	# or if you're fancy python date_formater.py a.file > a.file.tmp && mv a.file.tmp a.file
	with open(F_PATH, 'r') as f:
		# check for date validity
		# check for model in 3rd
		for l in f:
			l = l.strip('\n')
			if "/" in l: # check to see if the date was already changed
				y = l[findnth(l,'/',1)+1:l.index(',')] # year
				m = l[l.index('/')+1:findnth(l, '/',1)] # month
				d = l[:l.index('/')] # day
				rest = l[l.index(','):] # the rest of the string
				print "{}-{}-{}{},model".format(y,m,d,rest)
			else:
				print l

def merger_fixer():
	# removes model from 3rd col and puts the dates in the right spots
	# this function was designed to be implimeted using a
	# redirect in bash i.e. python date_formater.py a.file > b.file
	# or if you're fancy python date_formater.py a.file > a.file.tmp && mv a.file.tmp a.file
	dateDict = {}
	with open(F_PATH, 'r') as f:
		rdr = csv.reader(f, delimiter=',')
		for l in f:
			l = l.strip('\r\n').split(',')
			if l[0] in dateDict:
				if l[2] == "model":
					dateDict[l[0]].append(l[1])
				else:
					dateDict[l[0]].append(l[1])
					dateDict[l[0]][1], dateDict[l[0]][0] = dateDict[l[0]][0], dateDict[l[0]][1]
			else:
				dateDict[l[0]] = [l[1]]

	l = [[k,v] for k,v in dateDict.items()]
	for i in l:
		for j in i[1]:
			i.append(j)
		i.pop(1)
		print ','.join(i)
		
options = {
	1: date_formatter,
	2: merger_fixer
}

options[int(RG)]()