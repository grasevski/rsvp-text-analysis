#!/usr/bin/perl -w

use strict;
use DBI;

=head1 NAME

removeNegations - output matches and add a positivity flag

=head1 USAGE

./removeNegations.pl DB NEGATIONS_FILE

=head1 SYNOPSIS

The purpose of this script is to label matched keywords as either
positive (1) or negated (0) and to output the line number (in
user_xyz.csv where xyz could be sport, music etc), genre index and
positivity flag for each of the matches.

=head1 DESCRIPTION

Reads matches from STDIN, checks against NEGATIONS_FILE and outputs,
for each line from STDIN, a line containing line number (in
user_xyz.csv where xyz could be sport, music etc), genre index
(found by looking up keyword in DB) and either positive (1) or
negated (0), depending on whether the STDIN line number was found in
NEGATIONS_FILE.

=head1 REQUIRED ARGUMENTS

DB is the SQLite3 database containing the names (keyword,genre)
table. This is used to retrieve the genre index of a given keyword.

NEGATIONS_FILE is a newline-delimited list of line numbers which
should be negated in the matches. This file must be numerically
sorted in ascending order so that STDIN can be scanned at the same
time, ignoring lines from STDIN specified in NEGATIONS_FILE.

=cut

my $dbh = DBI->connect("dbi:SQLite:$ARGV[0]");
my $sth = $dbh->prepare('select genre from names where name = ?');
open my $fh, '<', $ARGV[1];
my $n = <$fh>;
if ($n) {chomp $n;} else {$n = 0;}
for (my $i=1; <STDIN>; ++$i) {
	chomp;
	my ($k, $v) = split ':', $_, 2;
	$sth->execute($v);
	if ($v = $sth->fetch) {
		print "$k $v->[0] ";
		if ($i == $n) {
			print '0';
			if ($n = <$fh>) {chomp $n;} else {$n = 0;}
		} else {print '1';}
		print "\n";
	}
}
