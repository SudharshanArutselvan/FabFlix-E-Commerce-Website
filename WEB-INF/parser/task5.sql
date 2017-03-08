create table stg_actors 
(stage_name varchar(100), 
first_name varchar(50), 
last_name varchar(50), 
dob date);


create table stg_movies 
(d_id varchar(32), 
director varchar(100), 
title varchar(100), 
year int, 
genre_name varchar(32));


create table stg_casts 
(d_id varchar(32), 
director varchar(100), 
title varchar(100), 
stage_name varchar(200));

LOAD DATA INFILE '/var/lib/mysql-files/actors.txt' 
INTO TABLE stg_actors FIELDS TERMINATED BY '|';

LOAD DATA INFILE '/var/lib/mysql-files/movies.txt' 
INTO TABLE stg_movies FIELDS TERMINATED BY '|';

LOAD DATA INFILE '/var/lib/mysql-files/casts.txt' 
INTO TABLE stg_casts FIELDS TERMINATED BY '|';

SET SQL_SAFE_UPDATES=0;

delete from stg_movies where year is null;

delete from stg_movies where title is null;

delete from stg_movies where director is null;

alter table stg_movies add id int not null auto_increment primary key;

CREATE INDEX stg_titles on stg_movies (title);

delete
from stg_movies using stg_movies,
    stg_movies e1
where stg_movies.id > e1.id
    and stg_movies.title = e1.title;    

ALTER TABLE stg_movies add check_movie int;

ALTER TABLE stg_casts 
add column first_name varchar(50), 
add column last_name varchar(50), 
add column check_star int;

CREATE INDEX stg_actor on stg_actors (first_name,last_name);
CREATE INDEX stg_name on stg_actors (stage_name);
CREATE INDEX stg_cast on stg_casts (stage_name);

update stg_casts, stg_actors 
set stg_casts.first_name = stg_actors.first_name,
    stg_casts.last_name = stg_actors.last_name
where stg_casts.stage_name = stg_actors.stage_name;

CREATE INDEX stg_castnames on stg_casts (first_name,last_name);

update stg_movies a, movies b 
set a.check_movie = 0 
where a.title = b.title;

update stg_movies 
set check_movie = 1 
where check_movie is null;

insert into movies (title, director, year)
select a.title, a.director, a.year 
from stg_movies a where 
check_movie = 1;

update stg_movies set genre_name = 'Drama' where genre_name = 'Dram';
update stg_movies set genre_name = 'Adventure' where genre_name = 'Advt';
update stg_movies set genre_name = 'Suspense' where genre_name = 'Susp';
update stg_movies set genre_name = 'Documentary' where genre_name = 'Docu';
update stg_movies set genre_name = 'Comedy' where genre_name = 'Comd';
update stg_movies set genre_name = 'Fantasy' where genre_name = 'Fant';
update stg_movies set genre_name = 'Horror' where genre_name = 'Horr';
update stg_movies set genre_name = 'Music' where genre_name = 'Musc';
update stg_movies set genre_name = 'Western' where genre_name = 'West';
update stg_movies set genre_name = 'History' where genre_name = 'Hist';
update stg_movies set genre_name = 'Romance' where genre_name = 'Romt';
update stg_movies set genre_name = 'Cartoon' where genre_name = 'Cart';
update stg_movies set genre_name = 'Biopic' where genre_name = 'Biop';
update stg_movies set genre_name = 'Action' where genre_name = 'Actn';
update stg_movies set genre_name = 'Mystery' where genre_name = 'Myst';
update stg_movies set genre_name = 'Suspense' where genre_name = '  Susp';
update stg_movies set genre_name = 'Sci-Fi' where genre_name = 'SciF';
update stg_movies set genre_name = 'Sci-Fi' where genre_name = 'ScFi';
update stg_movies set genre_name = 'Comedy' where genre_name = 'Comdx';
update stg_movies set genre_name = 'Mystery' where genre_name = 'Mystp';
update stg_movies set genre_name = 'Comedy Western' where genre_name = 'Comd West';
update stg_movies set genre_name = 'Drama' where genre_name = 'Dramd';
update stg_movies set genre_name = 'Disaster' where genre_name = 'Disa';
update stg_movies set genre_name = 'Violence' where genre_name = 'Viol';
update stg_movies set genre_name = 'Horror' where genre_name = 'Hor';
update stg_movies set genre_name = 'Action' where genre_name = 'Axtn';
update stg_movies set genre_name = 'Documentary' where genre_name = 'Ducu';
update stg_movies set genre_name = 'Romance Comedy' where genre_name = 'Romt Comd';
update stg_movies set genre_name = 'Drama' where genre_name = 'UnDr';
update stg_movies set genre_name = 'Noir Comedy Romance' where genre_name = 'Noir Comd Romt';
update stg_movies set genre_name = 'Drama Documentary' where genre_name = 'Dram Docu';
update stg_movies set genre_name = 'Romance Comedy' where genre_name = 'Romt. Comd';
update stg_movies set genre_name = 'Drama Action' where genre_name = 'Dram.Actn';
update stg_movies set genre_name = 'Porn' where genre_name = 'Porb';
update stg_movies set genre_name = 'Romance Drama' where genre_name = 'Romt Dram';
update stg_movies set genre_name = 'Action' where genre_name = 'Act';
update stg_movies set genre_name = 'Family' where genre_name = 'Faml';

insert into genres (name)
select distinct a.genre_name 
from stg_movies a 
where a.genre_name not in (select name from genres) 
      and a.genre_name is not null;

insert into genres_in_movies (movie_id,genre_id)
select a.id, c.id 
from movies a, stg_movies b, genres c 
where a.title = b.title 
      and b.genre_name = c.name
      and b.check_movie = 1;

delete from stg_casts where last_name is null;
 
alter table stg_casts add id int not null auto_increment primary key;

delete
from stg_casts using stg_casts,
    stg_casts e1
where stg_casts.id > e1.id
    and stg_casts.first_name = e1.first_name
    and stg_casts.last_name = e1.last_name
    and stg_casts.title = e1.title; 

update stg_casts a, stars b 
set a.check_star = 0 
where a.first_name = b.first_name 
      and a.last_name = b.last_name;

update stg_casts set check_star = 1 where check_star is null;

insert into stars (first_name, last_name)
select distinct first_name, last_name 
from stg_casts 
where check_star = 1;

insert into stars_in_movies (movie_id,star_id)
select a.id, c.id 
from movies a, stg_casts b, stars c, stg_movies d
where a.title = b.title 
and b.first_name = c.first_name
and b.last_name = c.last_name 
and a.title = d.title 
and d.check_movie = 1;

drop table stg_actors;
drop table stg_movies;
drop table stg_casts;