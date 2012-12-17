#!/usr/bin/perl -w

use strict;

my ($i, $out, $user) = (0, '', '');
for (open my $fh, '<', $ARGV[0]; <STDIN>; print "$out\n") {
	chomp;
	my ($k, $v) = split ':', $_, 2;
	++$i while $i < $k and $user = <$fh>;
	($out, $user) = split "\Q$v\E", $user, 2;
}
