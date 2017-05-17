#!/usr/bin/perl

use strict;
use warnings;

use LWP::Simple;

my $url = 'http://stackoverflow.com/questions/4669670/how-do-i-download-a-file-using-perl';
my $file = 'aa.html';

my $aa = getstore($url, $file);

print $aa;
