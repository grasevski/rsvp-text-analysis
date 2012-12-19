#!/usr/bin/perl -w

use strict;

=head1 NAME

outputTable - takes recorded matched features and outputs a table

=head1 USAGE

./outputTable.pl NUM_GENRES USER_IDS_FILE

=head1 SYNOPSIS

The purpose of this script is to output a feature table for each
entry in the freetext table. Each feature is either like (2),
dislike (0) or neither (1).

=head1 DESCRIPTION

The script creates a feature vector of size NUM_GENRES and prints an
entry for each id in USER_IDS_FILE. Matching features are read for
each user (in the order in which they occur in USER_IDS_FILE) from
STDIN by line number, feature index and either positive (1) or
negated (0). If a field occurs twice for a user as positive and
negated, the last result is stored. For this reason it is
recommended that STDIN is sorted on this field for consistency in
negation. Once all of the matches have been read for a user, the
userid and feature vector are printed out in a comma delimited
fashion.

=head1 REQUIRED ARGUMENTS

NUM_GENRES is the number of features, aka genres.

USER_IDS_FILE is a file with one userid per line and nothing else.
It is used to output the userid with each feature vector.

=cut

my @fields = (1) x $ARGV[0];
my ($k, $v, $b) = (0, 0, 0);
open my $fh, '<', $ARGV[1];
my $line = <STDIN>;
($k, $v, $b) = split ' ', $line, 3 if $line;
for (my $i=1; <$fh>; ++$i) {
	chomp;
	for (0 .. $#fields) {$fields[$_] = 1;}
	while ($i == $k) {
		chomp $b;
		--$v;
		if ($b) {$fields[$v] = 2;}
		else {$fields[$v] = 0;}
		if (defined ($line = <STDIN>)) {
			($k, $v, $b) = split ' ', $line, 3;
		} else {($k, $v, $b) = (0, 0, 0);}
	}
	print "$_,", (join ',', @fields), "\n";
}
