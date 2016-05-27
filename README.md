# Windex-builder

## Author and Create time
	Caitlynn Tian Zhou
	14 May 2016

## Last edited time
	27 May 2016

## Requirements

	* User need to install CPAN libraries
		* LWP::UserAgent:
			sudo perl -MCPAN -e shell
		    install LWP::UserAgent
		* LWP::HTTPS

## Installation and Usage
	* open Terminal and change the directory to the folder of the program
	* commands to run the program:
		* perl windex-build.pl (output filename) (start url) (excludeFile) (depth)* (output directory)*
		*  perl windex-build.pl test.txt http://en.wikipedia.org/wiki/Stack_overflow ./exclude.txt 3


