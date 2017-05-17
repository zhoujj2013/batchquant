use File::Fetch;
my $url = 'http://stackoverflow.com/questions/19913278/how-to-download-files-from-url-not-displaying-the-filename-using-perlscript';
my $ff = File::Fetch->new(uri => $url);
my $file = $ff->fetch() or die $ff->error;


#my $aa = `wget http://stackoverflow.com/questions/11451680/what-is-the-meaning-of-the-built-in-variab-perl`;
#
##`aa`;
##
#print "$aa";
#print $?;
#print "\n";
#print $? & 127;
#print "\n";
#print $? >> 8;
#print "\n";
#print "command failed" if ($?);
##
