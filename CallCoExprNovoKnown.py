import os, sys
import re
from scipy import stats
from math import log
import numpy as np

def usage():
	print '\nCaculate gene pair relationship, such as pearson r.\n'
	print 'Author: zhoujj2013@gmail.com\n'
	print 'Usage: '+sys.argv[0]+' <novo.log.expr> <known.log.expr> <pearsonr|spearmanr>  > result.txt'
	print 'Example: python ' + sys.argv[0] + ' novo.log.expr known.log.expr mESC_CM pearsonr > mESC_CM.PearsonR.lst'
	print ''
	print 'XX.expr format:'
	print 'id<tab>rpkm_value1<tab>rpkm_value2'
	print ''
	sys.exit(2)

if __name__ == "__main__":
	# check args
	if len(sys.argv) < 2:
		usage()
	
	expr_novo = sys.argv[1]
	expr_known = sys.argv[2]
	prefix = sys.argv[3]
	option = sys.argv[4]
	
	novo_fh = open(expr_novo, 'rb')
	
	while True:
		l = novo_fh.readline()
		if len(l) == 0:
			break
		lc = l.strip('\n').split('\t')
		
		novo_expr = [float(i) for i in lc[1:]]

		known_fh = open(expr_known, 'rb')
		while True:
			r = known_fh.readline()
			if len(r) == 0:
				break
			rc = r.strip('\n').split('\t')
			known_expr = [float(i) for i in rc[1:]]
			pearson_r = stats.pearsonr(novo_expr, known_expr)	
			if pearson_r[0] > 0.5 or pearson_r[0] < -0.5:
				print >>sys.stdout, lc[0] + '\t' + rc[0] + '\t' + str(pearson_r[0]) + '\t' + str(pearson_r[1])
		known_fh.close()
	novo_fh.close()
