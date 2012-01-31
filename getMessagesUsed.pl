#!/usr/bin/perl -w

use strict;

undef $/;

$_ = <>;

while ( $_ =~ /(?:wfMsg|msg|gM)\([\s\n]*(['"])([^'"\s\n]+)\1[^)]*\)/gs ) {
	print "$2\n";
}
