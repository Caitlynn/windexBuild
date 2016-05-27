use strict;
use warnings;
use HTML::TagParser;
use URL::Normalize;
use WWW::Mechanize;
use Exporter;

sub normaliseURL{
	my ($link) = shift;
	my $Normalizer = URL::Normalize->new( 'https://en.wikipedia.org'.$link);
	$Normalizer->make_canonical;
	my $currentURL = $Normalizer->url;
	return $currentURL;
}


sub getLinks{
	my $inputURL = shift;
	my $indexHash = shift;
	my $excludeArray = shift;
	my $globalArray = shift;
	my @activeLinks;
	my $mech = WWW::Mechanize->new();
	$mech->get($inputURL);
	# get the links from that page
	my @links = $mech->find_all_links();
	for my $link ( @links ) {
		# make all the links wiki inclusive, and also check the word in the exclusive array
		if (\$link->text =~ /([A-Z])\w+/ && $link->url =~ /^\/(wiki)\/\w+$/ && not(grep /$link->text/, @$excludeArray)){
			# normalise the url here
			my $norm = normaliseURL($link->url);
			# if the key already exists, append the link to the url array
			if (defined $indexHash->{$link->text}){
				# get the size of the corresponding value array
				my @links = $indexHash->{$link->text};
				if (not(grep /$norm/, @links)){
					push @{$indexHash->{$link->text}}, $norm;
				}

			# if the key is new, add the url to the first of the url array
			} else {
				$indexHash->{$link->text} = [$norm];
			}
			#sspush @globalArray, $link->text;
			if ( not ($norm~~@$globalArray) ){
				push @activeLinks, $norm;
			}
		}
	}
	return @activeLinks;
}


sub getWords{
	my( $inputURL) = shift;
	my $excludeArray = shift;
	my $indexHash = shift;
	my $html = HTML::TagParser->new( $inputURL );
	my $elem = $html->getElementById("mw-content-text");
	my $text = $elem->innerText();
	my @words = split / /, $text;
	my $norm = normaliseURL($inputURL);
	foreach my $word (@words){
		if ( $word=~ /([A-Z])\w+/ && not($word~~@$excludeArray)){
			if (defined $indexHash->{$word}){
				# make sure the link is unique
				my @links = $indexHash->{$word};
				if (not(grep /$norm/, @links)){
					push @{$indexHash->{$word}}, $norm;
				}
			} else {
					# if the key is new, add the url to the first of the url array
					$indexHash->{$word} = [$norm];
				}
		}
	}
}


1;