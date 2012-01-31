#!/opt/local/bin/perl -w

use strict;

my ( $prefix, $source, $dest ) = @ARGV;

my $langFh;

open my $sourceFh, '<', $source or die $!;
open my $destFh, '>', $dest or die $!;

while( <$sourceFh> ) {
	my $line = $_;

	if ( /\$messages\[["']([\w-]+)["']\]/ ) {	
		my $lang = $1;
		if ( $langFh ) {
			close $langFh or die $!;
		}
		open $langFh, '>>', "$lang.temp" or die $!;
	}

	if ( /\s+'$prefix/ ) {
		print {$langFh} $line;
	} else {
		print {$destFh} $line;
	}

}


close $sourceFh;	


