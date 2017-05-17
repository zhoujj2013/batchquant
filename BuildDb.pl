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
        Usage: $0 human/mouse

USAGE
print "$usage";
exit(1);
};

my $samplelst = "";
if($ARGV[0] eq "human"){
	$samplelst = "$Bin/human.sample.lst";
}elsif($ARGV[0] eq "mouse"){
	$samplelst = "$Bin/mouse.sample.lst";
}

open OUT,">","sample.raw.lst" || die $!;
open IN,"$samplelst" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	my $sample_name = $t[0];
	my $path = $t[1];
	my $file = "$sample_name.bam";
	print OUT "$sample_name\t$sample_name.bam\n";
	my $status = 5555;
	while($status != 200){
		print STDERR "Download failed: $path\n" unless($status == 5555);
		`rm $file` if(-f "$file");
		$status = getstore($path,$file);
		if($status == 200){
			last;
		}
	}
}
close IN;
close OUT;

# reheader
`perl $Bin/Reheader.pl sample.raw.lst $ARGV[0]`;

# other operation

