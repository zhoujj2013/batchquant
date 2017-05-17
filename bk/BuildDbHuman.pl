#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use File::Path qw(make_path);
use Data::Dumper;
use Cwd qw(abs_path);
use LWP::Simple;

&usage if @ARGV<1;

sub usage {
        my $usage = << "USAGE";

        Build databases for human.
        Author: zhoujj2013\@gmail.com 
        Usage: $0 human 

USAGE
print "$usage";
exit(1);
};

my $samplelst = "$Bin/human.sample.lst";

open IN,"$samplelst" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $path = $t[0];
	my $file = basename($path);
	my $status = 500;
	while($status != 200){
		`rm $file` if(-f "$file");
		$status = getstore($path,$file);
		if($status == 200){
			last;
		}
	}
}
close IN;

`perl $Bin/BatchReheader.pl $samplelst`;

