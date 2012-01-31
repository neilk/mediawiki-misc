#!/opt/local/bin/perl -w

use strict;

my @files;
{ 
  local $/ = undef;
  @files = <*.temp>;
}

for my $file ( @files ) {
  $file =~ /([\w-]+).temp/;
  next if -z $file;
  my $lang = $1;
  $lang =~ s/-/_/g;
  $lang = ucfirst( lc( $lang ) );
  my $langFilePrefix = 'languages/messages/Messages' . $lang;
  my $sourceFile = $langFilePrefix . '.php';
  my $destFile = $langFilePrefix . '.2.php';
  warn "$sourceFile -> $destFile";

  open my $sourceFh, '<', $sourceFile or die "can't open $sourceFile - $!";
  open my $destFh, '>', $destFile or die "can't open $destFile - $!";

  my $inMessages = 0;
  my $indent;
  while ( <$sourceFh> ) {
    my $line = $_;
    if ( not defined $indent and $inMessages ) { 
      $line =~ /^(\s*)/;
      $indent = $1;
    }
    if ( $line =~ /^(\s*)\$messages\s*=/ ) {
      $inMessages = 1;
    }
    if ( $inMessages and $line =~ /^\s*\)\s*;/ ) {
      print {$destFh} "\n";
      print {$destFh} "# Feedback\n";
      open my $fh, '<', $file or die $!;
      while ( <$fh> ) {
        my $fileLine = $_;
        $fileLine =~ s/^\s*//;
        $fileLine = $indent . $fileLine;
        print {$destFh} $fileLine;
      }
      close $fh or die $1;
    }
    print {$destFh} $line;

  }

  close $sourceFh or die $!;
  close $destFh or die $!;	

  rename $destFile, $sourceFile or die $!;
}



