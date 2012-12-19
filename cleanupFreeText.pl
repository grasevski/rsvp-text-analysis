#!/usr/bin/perl -w

use strict;
use Text::CSV;

=head1 NAME

cleanupFreeText.pl - clean up a csv file so that it is easy to parse

=head1 SYNOPSIS

The purpose of this script is to parse the (userid,freetext) comma
separated values and output sanitized comma separated values which
can be parsed simply by treating each line as a record and splitting
on the comma. This removes the issues of embedded commas and
newlines in the free text field.

=head1 DESCRIPTION

Parses a CSV file from STDIN, removes commas, newlines and quotation
marks from field 2 and prints to STDOUT.

=cut

my $csv = Text::CSV->new({binary => 1, eol => $/});
while (my $row = $csv->getline(*STDIN)) {
	$row->[1] =~ s/\n|,|"/ /g;
	$csv->print(*STDOUT, $row);
}
