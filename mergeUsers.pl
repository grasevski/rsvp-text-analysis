#!/usr/bin/perl -w

use strict;

=head1 NAME

mergeUsers - Merges consecutive records for the same user

=head1 SYNOPSIS

The purpose of this script is to merge duplicate userids
(from STDIN), so that there is one feature vector for each user,
which is then printed to STDOUT. The script only compares adjacent
rows for equal userid to ensure O(n) complexity, so the input should
be sorted by userid.

=head1 DESCRIPTION

The procedure works by accumulating rows for each userid, by
comparing the previous row with the current row. If they have the
same userid, the current row is merged into the previous row.
Otherwise if the rows do not match, the previous row is printed and
the current row is stored (to be used as the previous row in the
next iteration).

When merging 2 entries, for each feature, a '2' is assigned if
either entry has a '2' assigned, else a '0' is assigned if either
entry has a '0' assigned, else a '1' is assigned.

=cut

my $prev = 0;
my @fields = ();
while (<STDIN>) {
	chomp;
	my ($user, $fields) = split ',', $_, 2;
	if ($user == $prev) {
		my @t = split ',', $fields;
		for (0 .. $#fields) {
			if ($fields[$_] == 2 or $t[$_] == 2) {
				$fields[$_] = 2;
			} elsif ($t[$_] == 0) {$fields[$_] = 0;}
		}
	} else {
		print "$prev,", (join ',', @fields), "\n" if $prev;
		@fields = split ',', $fields;
		$prev = $user;
	}
}

print "$prev,", (join ',', @fields), "\n";
