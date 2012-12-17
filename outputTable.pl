#!/usr/bin/perl -w

use strict;

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
