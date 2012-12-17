#!/usr/bin/perl -w

use strict;
use DBI;

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
