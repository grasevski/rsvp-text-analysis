-- keyword-genre association table
create table names (
	name varchar(255) primary key,	-- the unique keyword
	genre integer not null	-- each genre has a 1-based index, based on its position in alphabetical order
);
