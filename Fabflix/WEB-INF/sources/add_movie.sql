DROP procedure IF EXISTS `add_movie`;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `add_movie`(
	OUT output varchar(200),
	IN movie_title varchar(100),
	IN movie_year int,
    	IN movie_director varchar(100),
    	IN m_banner_url varchar(200),
    	IN m_trailer_url varchar(200),
	IN star_first_name varchar(50),
	IN star_last_name varchar(50),
	IN genre_name varchar(32))
BEGIN 

DECLARE check1 int;
DECLARE outString1 varchar(50);
DECLARE outString2 varchar(50);
DECLARE outString3 varchar(50);
set check1 = 0;
set outString2= '';
set outString3= '';
SELECT 1 into check1 from movies where 
	exists ( select 1 from movies where movies.title = movie_title ) LIMIT 1;
    
if check1 <> 1 THEN
INSERT INTO movies (id,title,year,director,banner_url,trailer_url)
VALUES (DEFAULT,movie_title, movie_year, movie_director, m_banner_url,m_trailer_url);
select 'Movie Inserted' as 'mov';
set outString1='Movie Inserted';
set check1 = 0;
SELECT 1 into check1 from genres where 
	exists ( select 1 from genres where genres.name = genre_name) LIMIT 1;
    
if check1 <> 1 THEN
INSERT INTO genres (id,name)
VALUES (DEFAULT,genre_name);
select 'New genre - inserted' as 'gen';
set outString2='New genre created';
end if;

set check1 = 0;
SELECT 1 into check1 from stars where 
	exists ( select 1 from stars where stars.first_name = star_first_name and stars.last_name = star_last_name ) LIMIT 1;
    
if check1 <> 1 THEN
INSERT INTO stars (id,first_name,last_name)
VALUES (DEFAULT,star_first_name,star_last_name);
select 'New Star - inserted' as 'star';
set outString3='New star created';
end if;

insert into stars_in_movies (movie_id, star_id) values
((select id from movies where title = movie_title),
(select id from stars where stars.first_name = star_first_name and stars.last_name = star_last_name));

insert into genres_in_movies (movie_id, genre_id) values
((select id from movies where title = movie_title),
(select id from genres where name = genre_name));

select 'stars_in_movies and genres_in_movies tables updated' as 'last';
select concat(outString1,'|',outString2,'|',outString3) into output;
else
select 'The movie exists' as '';
set output='Movie already exists';
end if;

END$$

DELIMITER ;
