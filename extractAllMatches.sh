#!/bin/sh

for i in sport music movie; do
	cd $i
	../extractMatches.sh $i
	cp "$i"_table_neg.csv ../../sf_shared/smaller/final/output/$i.csv
	cp "$i"_table_neg.csv ~/.gvfs/serv1-disk\ on\ smartr510-serv1/USERS/nicholasg/moviesnstuff/final/output/$i.csv
	cd ..
done
