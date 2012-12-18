#!/bin/sh

# Feature extraction

# Reads a genre association file and a free text csv file and
# outputs a feature table.

# Usage: ../extractMatches.sh $1
#   where $1 is the genre
#   NB the ".." - this script must be run from a child directory of the folder containing the script
# Input:
#   $1 - command line argument (should be music, movie, or sport)
#   user_$1.csv - (userid,freetext) csv file exported from oracle
#   $1.txt - (keyword,genre) csv file consisting of the keyword-genre associations to be used
#   NB the input files must be in the current directory where the script is being run
# Output:
#   $1_table.csv - A csv file with either t or f for each attribute
#   $1_table_neg.csv - A csv file with either 0, 1 or 2 for each attribute
#   plus a bunch of intermediate files - NB best not to copy any files other than the input files into the folder, or they may be overwritten
#   NB - output files have unix line breaks

if [ $# -ne 1 ]; then echo "Usage: $0 TYPE" && exit 0; fi
echo "Sanitizing user_$1.csv..."
tail -n+2 user_$1.csv|tr -d '\r'|tr '[:upper:]' '[:lower:]'|../cleanupFreeText.pl|sed 's/^\s\+\|\s\+$//g'|sed 's/\s\+/ /g'|tee user_$1.txt|cut -f1 -d','>user_$1_id.txt
echo "Sanitizing $1.txt..."
tr -d '\r'<$1.txt|tr '[:upper:]' '[:lower:]'|tee $1.csv|cut -f1 -d','>$1_names.txt
echo "Processing genres..."
cut -f2 -d',' $1.csv|tee -a $1_names.txt|sort|uniq|tee $1_genres.csv|sed 's/$/,/'|xargs echo id,|sed 's/,$//'|tee $1_table.csv>$1_table_neg.csv
echo "Sorting and removing duplicates from keywords file..."
sort $1_names.txt|uniq>$1_names.csv
echo "Searching for keywords in free text..."
cut -f2 -d',' user_$1.txt|tee user_$1_text.txt|grep --mmap -Fwonf $1_names.csv|tee $1_matches.txt|../getPossibleNegations.pl user_$1_text.txt|grep --mmap -Fwnf ../negative.txt|cut -f1 -d':'>$1_negations.txt
echo "Creating keyword association database..."
rm -f $1.db && sqlite3 $1.db<../schema.sql
echo "Populating keyword association database..."
../populate.pl $1.db $1_genres.csv<$1.csv
echo "Creating feature tables..."
../removeNegations.pl $1.db $1_negations.txt<$1_matches.txt|sort -k1n,1 -k2n,2|uniq|../outputTable.pl `wc -l<$1_genres.csv` user_$1_id.txt|sort -k1n,1|../mergeUsers.pl|tee -a $1_table_neg.csv|sed 's/,2/,t/g'|sed 's/,\(0\|1\)/,f/g'>>$1_table.csv
