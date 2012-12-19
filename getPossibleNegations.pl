#!/usr/bin/perl -w

use strict;

=head1 NAME

getPossibleNegations - prints the strings which may contain negations

=head1 USAGE

./getPossibleNegations.pl USER_FREE_TEXT_FILE

=head1 SYNOPSIS

The purpose of this script is to produce for each matched keyword
the string immediately preceding it. It prints one such string per
line to STDOUT. This list can then later be used with grep to find
which keywords have been negated.

=head1 DESCRIPTION

Reads a list of matches from STDIN and a list of free text entries
from USER_FREE_TEXT_FILE. The matches should be an ordered series of
"lineno:keyword" lines. The free text is then split on each of these
keywords in succession, and the text immediately preceding each
keyword is outputted to STDOUT on a separate line.

=head1 REQUIRED ARGUMENTS

USER_FREE_TEXT_FILE is a list of free text entries, with one free
text entry per line. This corresponds to the initial csv file
generated from Oracle, and should be in the same order. It is
essentially the initial csv with the first column omitted.

=cut

my ($i, $out, $user) = (0, '', '');
for (open my $fh, '<', $ARGV[0]; <STDIN>; print "$out\n") {
	chomp;
	my ($k, $v) = split ':', $_, 2;
	++$i while $i < $k and $user = <$fh>;
	($out, $user) = split "\Q$v\E", $user, 2;
}
