#!/usr/bin/perl -w

use strict;
use Text::CSV;

my $csv = Text::CSV->new({binary => 1, eol => $/});
while (my $row = $csv->getline(*STDIN)) {
	$row->[1] =~ s/\n|,|"/ /g;
	$csv->print(*STDOUT, $row);
}
