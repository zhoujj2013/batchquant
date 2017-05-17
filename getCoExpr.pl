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

        Get coexpression relation from multiple tissue RNA-seq(human).
        Author: zhoujj2013\@gmail.com 
        Usage: $0 xx.gtf sample.lst query.sample.bam prefix

USAGE
print "$usage";
exit(1);
};

my $gtf=shift;
my $sample_f = shift;
my $bam = shift;
my $prefix = shift;

`echo -e "$prefix\t$bam" | cat - $sample_f > ./$prefix.sample.lst`;

`perl $Bin/BatchQuantification.pl ./$prefix.sample.lst $gtf`;

my %GExprDb;
open IN,"$Bin/../data/all.remain.log.lst" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	$GExprDb{$t[0]} = 1;
}
close IN;

`python $Bin/CheckGenes.py ./all.samples.expr all`;

my %novo;
my %known;
my %g;

open NOVOLOG,">","./novo.log.expr" || die $!;
open KNOWNLOG,">","./known.log.expr" || die $!;
open IN,"./all.remain.log.lst" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	if(exists $GExprDb{$t[0]}){
		$known{$t[0]} = 1;
		print KNOWNLOG "$_\n";
	}else{
		$novo{$t[0]} = 1;
		print NOVOLOG "$_\n";
	}
	$g{$t[0]} = 1;
}
close IN;
close NOVOLOG;
close KNOWNLOG;

open NOVO,">","./novo.expr" || die $!;
open IN,"./all.samples.expr" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	if(exists $novo{$t[0]}){
		print NOVO "$_\n";
	}
}
close IN;
close NOVO;


`python $Bin/CallCoExpressionPair.py ./novo.expr novo pearsonr > novo.PearsonR.lst`;
`python $Bin/CallCoExprNovoKnown.py ./novo.log.expr ./known.log.expr novo.vs.known pearsonr > novo.vs.known.PearsonR.lst`;

# summarized co-expression
open IN,"$Bin/../data/all.PearsonR.lst" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	if(exists $g{$t[0]} && exists $g{$t[1]}){
		print "$t[0]\t$t[1]\tgg\t$t[2]\tco-express\n";
	}
}
close IN;

open IN,"./novo.PearsonR.lst" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	if(exists $g{$t[0]} && exists $g{$t[1]}){
		print "$t[0]\t$t[1]\tgg\t$t[2]\tco-express\n";
	}
}
close IN;

open IN,"./novo.vs.known.PearsonR.lst" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	if(exists $g{$t[0]} && exists $g{$t[1]}){
		print "$t[0]\t$t[1]\tgg\t$t[2]\tco-express\n";
	}
}
close IN;
