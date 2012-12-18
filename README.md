rsvp-text-analysis
==================

Text mining scripts for the RSVP database


Synopsis
--------
This repository consists of a main script extractMatches.sh, as well as some auxilliary files and helper perl scripts. The purpose of extractMatches.sh is to output a feature table given a list of user ids and corresponding free text fields (NB the user ids need not be unique).

This is the basic procedure followed by extractMatches.sh:

1. Find all keywords in the free text and (in order) record the line number (=> userid) and keyword matched.
2. Search the text before each keyword for matches from the negative.txt file and record any negations.
3. Read through the matches and negations and output a table, assigning for each genre a '2' for a successful match, '0' for a negation and '1' if no keywords from that genre were mentioned by the user.
4. Sort the table by userid and merge records of the same user, using a '2' if one matched successfully, else '0' if one was negated, else '1'.


Dependencies
-------------
These utilities were written under unix, and thus have the following dependencies:

1. unix shell (eg bash)
2. text utilities - grep, sed, tr, tee, cut, sort, uniq, tail
3. perl
4. sqlite3

Recommended windows dependency installation (not tested):

1. install cygwin
2. install aforementioned dependencies in cygwin

Most unix distributions include these dependencies, and any missing ones can be installed through the package manager.


Installation
------------

1. Install dependencies
2. Download and extract this repository


Setup
-----
These scripts rely on the following main data files:

* rsvp-text-analysis/negative.txt	- list of negating phrases, used for determining negation. Each line of this file should be a negating phrase with no leading or trailing whitespace. This file is provided, however it can be updated as seen fit.
and the following files must be provided for each feature type:
* rsvp-text-analysis/myfeaturetype/myfeaturetype.txt	- (keyword,genre) csv file. This file consists of an association list of keywords and genres. Each line of this file should be a keyword followed by a comma followed by a genre, with no leading or trailing whitespace. Genres are automatically included as keywords in the script.
* rsvp-text-analysis/myfeaturetype/user_myfeaturetype.csv	- (userid, freetext) csv file exported from the RSVP Oracle database. There should only be 2 columns - one for userid and one for free text. The first line should be a header, and each subsequent line should be a (userid,freetext) pair.


File Formats
------------
negative.txt should consist of a list of phrases. There should be no leading or trailing whitespace. Eg:

    not
    except
    dont like

myfeaturetype.txt should consist of a list of "keyword,genre" pairs. There should be no leading or trailing whitespace. Eg:

    alice in chains,rock
    bach,classical
    nirvana,rock
    frank sinatra,jazz

user_myfeaturetype.csv should be a comma-separated-value file exported from oracle. It should have exactly 2 columns - userid and freetext. The user ids need not be unique, as all features for a given userid are eventually merged. This means that one can concatenate multiple tables if they wish to use multiple text fields. For example one could concatenate a (userid,idealpartner) table with a (userid,sport) table, and so on, to cover multiple free text fields. Below is an example csv file:

    "USERID","XYZ"
    234123,"i like all music usher, jay-z, ne-yo, 50-cent snoop dogg,
    puff daddy,
    shaggy
    
    etc
    "
    53453,"im a sensitive guy"
    234123,"large and in charge!"
    11111,"
    
    "
    123456,""
    666777,"
    "

myfeaturetype_table.csv is an outputted feature table, with 't' representing like and 'f' representing dont like for each feature. Eg:

    id, blues, classical, country, data, folk, jazz, misc, newage, reggae, rock, soundtrack
    2044740,f,t,f,f,t,f,t,f,f,t,f
    2044741,t,t,f,f,t,f,t,t,f,t,t
    2044742,t,t,f,f,t,t,t,f,f,t,t
    2044743,f,f,f,f,t,t,t,f,t,t,t
    2044745,f,t,t,f,t,t,t,f,f,t,t
    2044746,f,f,f,f,f,f,t,f,f,t,t
    2044747,f,f,f,f,t,f,t,f,t,t,t

myfeaturetype_table_neg.csv is an outputted feature table, with '2' representing like, '0' representing dislike and '1' representing neutral (i.e. not mentioned). Eg:

    id, blues, classical, country, data, folk, jazz, misc, newage, reggae, rock, soundtrack
    2044740,1,2,1,1,2,1,2,1,1,2,1
    2044741,2,2,1,1,2,1,2,2,1,2,2
    2044742,2,2,1,1,2,2,2,1,1,2,2
    2044743,1,1,1,1,2,2,2,1,2,2,2
    2044745,1,2,2,1,2,2,2,1,1,2,2
    2044746,1,1,1,1,1,1,2,1,1,2,2


Usage
-----
Creating a feature table:

    $ cd /path/to/rsvp-text-analysis
    $ mkdir myfeaturetype
    $ cd myfeaturetype
    $ cp /my/user/table/freetext/entries.csv user_myfeaturetype.csv
    $ cp /my/keyword/associations.txt myfeaturetype.txt
    $ ../extractText.sh myfeaturetype
    $ cp myfeaturetype_table.csv myfeaturetype_table_neg.csv /somewhere/else/


Resources
---------
The following sources may be useful when creating keyword association files:

* [The IMDB data set](http://www.imdb.com/interfaces)
* [imdbpy](http://imdbpy.sourceforge.net/) - Python api for IMDB. This for example could be used in conjunction with the IMDB data set to populate a local SQLite database. This could then in turn be queried to return a list of (movie,genre) pairs for example.
* [The freedb music cd data set](http://www.freedb.org/en/download__database.10.html) - This could be used to populate an (artist,genre) keyword association file.
* [A list of sports, divided by category](http://en.wikipedia.org/wiki/List_of_sports)
