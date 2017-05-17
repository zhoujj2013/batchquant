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

        This script create makefile for LncFunNet analysis.
        Author: zhoujj2013\@gmail.com 
        Usage: $0 config.cfg

USAGE
print "$usage";
exit(1);
};

my $sampleList = shift;
my $spe= shift;

my $conf="$Bin/config.txt";
my %conf;
&load_conf($conf, \%conf);

my $picard = $conf{PICARD};
my $samtools = $conf{SAMTOOLS};

open OUT1,">","sample.lst" || die $!;
open OUT,">","./run_reheader.sh" || die $!;
open IN,"$sampleList" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	print OUT1 "$t[0]\t$t[0].rh.bam\n";
	if($spe eq "human"){
		print OUT "java -jar $picard ReplaceSamHeader I=$t[1] HEADER=$Bin/human.header.sam O=$t[0].rh.bam\n";
	}elsif($spe eq "mouse"){
		print OUT "$samtools reheader $Bin/mouse.header.sam $t[1] > $t[0].rh.bam\n";
	}
}
close IN;
close OUT;
close OUT1;

`sh ./run_reheader.sh`;

###########################
sub load_conf
{
    my $conf_file=shift;
    my $conf_hash=shift; #hash ref
    open CONF, $conf_file || die "$!";
    while(<CONF>)
    {
        chomp;
        next unless $_ =~ /\S+/;
        next if $_ =~ /^#/;
        warn "$_\n";
        my @F = split"\t", $_;  #key->value
        $conf_hash->{$F[0]} = $F[1];
    }
    close CONF;
}
