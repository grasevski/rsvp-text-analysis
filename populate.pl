#!/usr/bin/perl -w

use strict;
use DBI;

=head1 NAME

populate - populate the keyword-genre SQLite3 table

=head1 USAGE

./populate.pl DB GENRES_FILE

=head1 SYNOPSIS

The purpose of this script is to read the (keyword,genre)
associations from STDIN and insert them as entries into
the DB.

=head1 DESCRIPTION

The genres are initially inserted into the database, then each line
of STDIN is inserted into the database in turn. The line is ignored
if the keyword is already in the table, seeing as each keyword is
only allowed to map to one genre (keyword is the primary key in the
names table). This means the order of the records in STDIN is
important, as only the first record for a given keyword will be
recorded. Thus it is recommended that the records are ordered by the
likelihood of being intended by a user, with the most likely
associations first.

=head1 REQUIRED ARGUMENTS

DB is the SQLite3 database containing the names table specified in
schema.sql. This DB will serve as a mapping from keywords to genre
(feature) indexes, thus allowing for matches to be identified by the
feature which they represent.

GENRES_FILE is a list of genres. These genres are given indices,
starting from 1. Genres are also initially mapped to themselves, so
that if a user for example states "I like rock music", they will get
a match for the rock category.

=cut

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
