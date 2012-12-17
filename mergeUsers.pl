#!/usr/bin/perl -w

use strict;

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
