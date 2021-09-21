#!/bin/python3

f3 = open('list.txt','a')
with open("subdomains.txt",'r') as f1:
	with open("outofscope.txt",'r') as f2:
		file1=f1.readlines()
		file2=f2.readlines()
		for i in file1:
			if(i in file2):
				continue
			else:
				f3.write(i)
				

f3.close()