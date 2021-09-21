#!/bin/python3

import sys

if(len(sys.argv) < 3):
	print("usage: ./brute.py wordlist domain.name")

try:
	with open(sys.argv[1],'r') as file1:
		wordlist=file1.readlines()
		for word in wordlist:
			print(f"{word.strip()}.{sys.argv[2]}")
except:
	print("usage :\n ./brute.py ../wordlist.txt domain.txt")