#!/bin/sh

tail -n+2 user_$1.csv|tr -d '\r'|tr '[:upper:]' '[:lower:]'|../cleanupFreeText.pl|sed 's/^\s\+\|\s\+$//g'|sed 's/\s\+/ /g'|tee user_$1.txt|cut -f1 -d','>user_$1_id.txt
tr '[:upper:]' '[:lower:]'<$1.txt|tee $1.csv|cut -f1 -d','>$1_names.txt
cut -f2 -d',' $1.csv>>$1_names.txt
sort $1_names.txt|uniq>$1_names.csv
cut -f2 -d',' $1.csv|sort|uniq|tee $1_genres.csv|sed 's/$/,/'|xargs echo id,|sed 's/,$//'|tee $1_table.csv>$1_table_neg.csv
cut -f2 -d',' user_$1.txt|tee user_$1_text.txt|grep --mmap -Fwonf $1_names.csv|tee $1_matches.txt|../getPossibleNegations.pl user_$1_text.txt|grep --mmap -Fwnf ../negative.txt|cut -f1 -d':'>$1_negations.txt
rm -f $1.db && sqlite3 $1.db<../schema.sql
../populate.pl $1.db $1_genres.csv<$1.csv
../removeNegations.pl $1.db $1_negations.txt<$1_matches.txt|sort -k1n,1 -k2n,2|uniq|../outputTable.pl `wc -l<$1_genres.csv` user_$1_id.txt|sort -k1n,1|../mergeUsers.pl|tee -a $1_table_neg.csv|sed 's/,2/,t/g'|sed 's/,\(0\|1\)/,f/g'>>$1_table.csv
