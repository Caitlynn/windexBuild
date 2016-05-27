#!/usr/bin/perl -w
use strict;
use WWW::Mechanize;
use URL::Normalize;
use HTML::TagParser;
use URI::Fetch;
use Data::Dumper qw(Dumper);

use warnings;
use ValidateArgs;
use DealData;
use URLHandler;

my ($name, $starturl, $excludeFile, $depth , $dir) = validateArgs(@ARGV);

our %indexHash = ();
our @globalArray;
our $globalCounter = 3;
our @excludeArray = generateExclude($excludeFile);

implementRecursive($depth, $starturl);
writeToFile($name);

sub implementRecursive{
	my $depth = shift;
	my $inputURL = shift;

	my @linkArray = getLinks($inputURL,\%indexHash, \@excludeArray, \@globalArray);
	$depth -= 1;

	for my $link (@linkArray){
		getWords($link, \@excludeArray,\%indexHash);
		$globalCounter = $globalCounter - 1;
		if ($globalCounter < 0){
			return;
		}
		if ( not($link~~@globalArray) && $depth != 0 ){
			push @globalArray, $link;
		implementRecursive($depth, $link);
		}
	}
	return;

}


sub writeToFile{
	my ($fileName) = shift;
	# Attempts to open the file
	open( my $fh, '+<', $fileName ) or die "The file name is invalid";
	my @keys = keys %indexHash;
 	foreach my $key (@keys){
 		if ($key =~ /^\s*\S+\s*$/ ){
			print $fh "$key";
			my $lengthArray = scalar @{$indexHash{$key}};
			while ($lengthArray > 0){
				# print all the
				my $value = $indexHash{$key}[$lengthArray-1];
				print $fh ",$value";
				$lengthArray = $lengthArray - 1;
			}
			print $fh "\n";
		}
	}
    close $fh;
}




