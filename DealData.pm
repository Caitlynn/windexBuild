use strict;
use warnings;
use Exporter;

sub generateExclude{
	my($file) = shift;
	open my $temp, '<', $file;
	chomp( my @content = <$temp>);
	close $temp;
	return @content;
}

1;