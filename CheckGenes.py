import os, sys
import re
from scipy import stats
from math import log
import numpy as np

def usage():
	print '\nCaculate gene pair relationship, such as pearson r.\n'
	print 'Author: zhoujj2013@gmail.com\n'
	print 'Usage: '+sys.argv[0]+' <combine.expr.matrix> <prefix>'
	print 'Example: python ' + sys.argv[0] + ' mESC_CM_combine.expr mESC_CM '
	print ''
	print 'XX.expr format:'
	print 'id<tab>rpkm_value1<tab>rpkm_value2'
	print ''
	sys.exit(2)

if __name__ == "__main__":
	# check args
	if len(sys.argv) < 2:
		usage()
	
	expr_f = sys.argv[1]
	expr_fh = open(sys.argv[1], 'rb')
	expr_c = {}
	expr_e = {}
	idArr = []
	
	prefix = sys.argv[2]
	
	remain_fh = open('./' + prefix + '.remain.lst', 'wb')
	log_fh = open('./' + prefix + '.remain.log.lst', 'wb')
	while True:
		l = expr_fh.readline()
		if len(l) == 0:
			break
		l = l.strip('\n')
		lc = l.split('\t')
			
		expr_c[lc[0]] = lc
		
		expr_ee = [float(i) for i in lc[1:]]
		expr_log = [log(float(i)+1,2) for i in lc[1:]]
		
		if np.var(np.array(expr_log)) < 0.05:
			continue
		
		idArr.append(lc[0])	
		expr_e[lc[0]] = [log(float(i)+1,2) for i in lc[1:]]
		
		#print np.var(np.array(expr_ee))
		#print np.var(np.array(expr_e[lc[0]]))	
	
		expr_str_arr = []
		for i in range(0,len(expr_ee)):
			expr_log = log(expr_ee[i]+1, 2)
			expr_str_arr.append(str(expr_log))

		expr_str = "\t".join(expr_str_arr)
		
		print >>log_fh, lc[0] + '\t' + expr_str
		#print >>sys.stderr, expr_e[lc[0]]
		print >>remain_fh,l
		
	remain_fh.close()
	log_fh.close()
