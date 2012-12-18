#!/bin/sh

# Batch feature extraction

# Runs extractMatches.sh for sport, music and movie and copies the
# resultant tables to various places. This batch script also serves
# as a use case for extractMatches.sh.
# NB paths are relative, so it must be run from the same directory
# as this script.

for i in sport music movie; do
	cd $i
	../extractMatches.sh $i
	cp "$i"_table_neg.csv ../../sf_shared/smaller/final/output/$i.csv
	cp "$i"_table_neg.csv ~/.gvfs/serv1-disk\ on\ smartr510-serv1/USERS/nicholasg/moviesnstuff/final/output/$i.csv
	cd ..
done
