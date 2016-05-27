use strict;
use Exporter;

sub validateArgs {
	my ($name, $starturl, $excludeFile, $depth , $dir) = @_;
	if (@_ < 3 || @_ > 5){
		die "Please enter enough number of arguments.!", "\n"
	}

	if (not defined $name) {
		die "Please enter the name of the index!","\n";
	}

	if (not defined $starturl) {
		die "Please enter the Wikipedia URL where you would like to begin your index. For example,
			you might want to start at https://en.wikipedia.org/wiki/Perl. ","\n";
	}

	if (not defined $excludeFile) {
		die "Please enter the file containing the words you DON'T want to index.","\n";
	} elsif (not -f $excludeFile){
		die "This is not a valid file!", "\n";
	}
	
	if (not defined $depth) {
		# set depth to 3 if user doesnt input any
		$depth = 3;
	} else {
		isInt($depth);
		if($depth < 1 || $depth > 5){
			die "The depth should be between 1 and 5 (include 1 and 5))!","\n";
		}
	}

	if (not defined $dir) {
		$dir = "./";
	} elsif (not -d $dir) {
		die "This is not a valid directory!","\n";
	}
	return($name, $starturl, $excludeFile, $depth , $dir);
}

# check if the input argument is a integer
sub isInt {
	my $var = shift;
	if ($var !~ /^\d+?$/) {
		die "depth has to be an integer between 1 and 5!","\n";
	}
}

1;