#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use File::Path qw(make_path);
use Data::Dumper;
use Cwd qw(abs_path);

&usage if @ARGV<1;

sub usage {
        my $usage = << "USAGE";

        This script design for quantify multiple samples.
        Author: zhoujj2013\@gmail.com 
        Usage: $0 sample.lst XX.gtf

USAGE
print "$usage";
exit(1);
};

my $sample_f = shift;
my $gtf_f = shift;

my $conf="$Bin/config.txt";
my %conf;
&load_conf($conf, \%conf);

my $cufflinks = $conf{CUFFLINKS};

open OUT,">","run_cufflink.sh" || die $!;
open IN,"$sample_f" || die $!;
while(<IN>){
	chomp;
	next if(/^#/);
	my @t  = split /\t/;
	#print OUT "cufflinks -p 8 --library-type fr-firststrand -G $gtf_f $t[1] -o ./$t[0] > $t[0].log 2>$t[0].err\n";
	print OUT "$cufflinks -p 8 -G $gtf_f $t[1] -o ./$t[0] > $t[0].log 2>$t[0].err\n";
	# fr-firststrand 
}
close IN;
close OUT;

`sh run_cufflink.sh`;

my $str= "";
open IN,"$sample_f" || die $!;
while(<IN>){
	chomp;
	next if(/^#/);
	my @t = split /\t/;
	$str .=" $t[0]/genes.fpkm_tracking:$t[0]";
}
close IN;

`python $Bin/combine_cuff_expr.py $str > all.samples.expr.raw`;
`grep -v "^ensemblid" all.samples.expr.raw | cut -f 1,4- > all.samples.expr`;


