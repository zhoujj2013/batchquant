import os, sys
import re

def usage():
	print '\nCombine cufflink quantification result to matrix\n'
	print 'Author: zhoujj2013@gmail.com 8/29/2016\n'
	print 'Usage: python '+sys.argv[0]+' 1.gene_tracking:aa 2.gene_tracking:bb ...'
	print ''
	sys.exit(2)

# check args
if len(sys.argv) < 2:
	usage()



program = sys.argv.pop(0)

geneid = {}
for p in sys.argv:
	pc = p.split(':')
	f = open(pc[0], 'rb')
	f.readline()
	while True:
		l = f.readline()
		if len(l) == 0:
			break
		c = l.split('\t')
		#if re.search(r'^ENS',c[0]):
		if c[0] not in geneid:
			geneid[c[0]] = []
			geneid[c[0]].append(c[4])
			geneid[c[0]].append(c[6])
	f.close()

#print geneid

header = []
header.append("ensemblid")
header.append("geneid")
header.append("locate")

for p in sys.argv:
	pc = p.split(':')
	header.append(pc[1])
	f = open(pc[0], 'rb')
	f.readline()
	expr = {}
	while True:
		l = f.readline()
		if len(l) == 0:
			break
		l = l.strip('\n')
		c = l.split('\t')
		#if re.search(r'^ENS',c[0]):
		if c[0] not in expr:
			expr[c[0]] = c[9]
	f.close()
	for k,v in geneid.items():
		if k in expr:
			geneid[k].append(expr[k])
		else:
			geneid[k].append("0")

print "\t".join(header)
for k,v in geneid.items():
	print k + '\t',
	print "\t".join(geneid[k])

