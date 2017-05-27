CREATE TABLE movies(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
title VARCHAR(100) NOT NULL,
year INT NOT NULL,
director VARCHAR(200) NOT NULL,
banner_url VARCHAR(200),
trailer_url VARCHAR(200)

);

CREATE TABLE stars(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name  VARCHAR(50) NOT NULL,
dob DATE ,
photo_url VARCHAR(200)

);

CREATE TABLE stars_in_movies(
star_id INT,
movie_id INT,
FOREIGN KEY (star_id) REFERENCES stars(id),
FOREIGN KEY (movie_id) REFERENCES movies(id)

);

CREATE TABLE genres(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(32) 
);

CREATE TABLE genres_in_movies(
genre_id INT NOT NULL ,
movie_id INT NOT NULL ,
FOREIGN KEY (genre_id) REFERENCES genres(id),
FOREIGN KEY (movie_id) REFERENCES movies(id)
);
CREATE TABLE creditcards(
id VARCHAR(20) NOT NULL PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
expiration DATE NOT NULL
);

CREATE TABLE customers(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
cc_id VARCHAR(20) NOT NULL,
address VARCHAR(200) NOT NULL,
email VARCHAR(50) NOT NULL,
password VARCHAR(20) NOT NULL,
FOREIGN KEY (cc_id) REFERENCES creditcards(id)

);

CREATE TABLE sales(
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
customer_id INT NOT NULL,
movie_id INT NOT NULL,
sale_date DATE NOT NULL,
FOREIGN KEY (customer_id) REFERENCES customers(id),
FOREIGN KEY  (movie_id) REFERENCES movies(id)

);

CREATE TABLE employees(
email varchar(50) primary key,
password varchar(20) not null,
fullname varchar(100)
);








