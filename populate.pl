#!/usr/bin/perl -w

use strict;
use DBI;

my $dbh = DBI->connect("dbi:SQLite:$ARGV[0]", undef, undef, {AutoCommit => 0, RaiseError => 1});
my %sths = (insertSth => 'insert into names values (?, ?)',
	selectSth => 'select genre from names where name = ?');
for (keys %sths) {$sths{$_} = $dbh->prepare($sths{$_});}
open my $fh, '<', $ARGV[1];
my %genres = ();
$dbh->do('pragma synchronous=0');
for (my $i=1; <$fh>; ++$i) {
	chomp;
	$genres{$_} = $i;
	$sths{insertSth}->execute($_, $i);
}
$dbh->commit;
while (<STDIN>) {
	chomp;
	my ($k, $v) = split ',', $_, 2;
	$sths{selectSth}->execute($k);
	if (not defined $sths{selectSth}->fetch) {
		$sths{insertSth}->execute($k, $genres{$v});
	}
}
$dbh->commit;
