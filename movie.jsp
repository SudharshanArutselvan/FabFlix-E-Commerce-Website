<html>
<%@ page import="java.io.*,java.net.*,java.sql.*,javax.sql.*,java.text.*,java.util.*,javax.servlet.*,javax.servlet.http.*"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<head>
	<title>Fablix</title>
	<link rel="icon" type="image/jpg" href="icon.jpg" />
	<link rel="stylesheet" type="text/css" href="main.css">
	<link rel="stylesheet" type="text/css" href="bootstrap.min.css">
	<script src="jquery-3.1.1.min.js"></script>
    <meta charset="UTF-8">
    <style>
    	.movies-list{
			width:620px;
		}
		#genresList{
			width:620px;
		}
		@media only screen(max-width:650px){
			.movies-list{
				width:550px;
				display:inline-block;
			}
			#genresList{
				width:550px;
			}
		}
		@media only screen(max-width:450px){
			.movies-list{
				width:100%;
				display:inline-block;
			}
			#genresList{
				width:100%;
			}
		}
    </style>
</head>
<body style="">
	<div id="mainHeading" class="row" style="">
		<div class="col-md-3" id="logoHeading" style="margin:21px 0px;left:0;">Fablix</div>
		<form class="col-md-6"><input class="inputbox" type="text" name="search" placeholder="Search" style="border-radius:10px;"></form>
		<div class="col-md-3" Style="margin:35px 0px;right:0;position:absolute;font-size:18px;"><%out.print(session.getAttribute("name"));%></div>
	</div>
	<center>
		<div class="row movies-list" style="margin:20px;">
			<% 
				String user = "user";
				String pw = "vidhya567";
				String url = "jdbc:mysql://localhost:3306/moviedb";
				Class.forName("com.mysql.jdbc.Driver").newInstance();
				Connection dbcon  = DriverManager.getConnection(url, user, pw);
				Statement statement = dbcon.createStatement();
				String moviequery = "SELECT * from movies where id="+request.getParameter("id");
				ResultSet movieresult = statement.executeQuery(moviequery);
				while(movieresult.next())
				{  
					int movieID = movieresult.getInt("id");
					String moviename = movieresult.getString("title");
					String banner_url = movieresult.getString("banner_url");
					int year = movieresult.getInt("year");
					String director = movieresult.getString("director");
					out.println("<div class='row movie-card' style='padding:15px;width:100%' href='/movie?id="+movieID+"'><div class='poster' style='width:240px;height:240px;float:left;'><img src='"+banner_url+"' onerror='placeholder(this);' style='height:100%;width:100%;pointer:cursor;'></div><div style='position:absolute;margin-left:260px;'><div class='movieID' style='padding:10px;text-align:left;'>"+movieID+"</div><div class='movieTitles' style='padding:10px;text-align:left;'>"+moviename+"</div><div class='year' style='padding:10px;text-align:left;'>"+year+"</div><div class='director' style='padding:10px;text-align:left;'>"+director+"</div>");
					Statement statement2 = dbcon.createStatement();
					String starquery = "SELECT star_id from stars_in_movies where movie_id="+movieID;
					ResultSet starresult = statement2.executeQuery(starquery);
					out.println("<div class='stars' style='padding:10px;text-align:left;'>");
					while(starresult.next()){
						int starID = starresult.getInt("star_id");
						Statement statement3 = dbcon.createStatement();
						String starnamequery = "SELECT * from stars where id="+starID;
						ResultSet starnameresult = statement3.executeQuery(starnamequery);
						starnameresult.next();
						String starname = starnameresult.getString("first_name")+" "+starnameresult.getString("last_name");
						out.println("<a class='stars_link' href='/Fablix/star?id="+starID+"' style='text-align:left;'>"+starname+"</a>");
					}
					out.println("</div>");
					Statement statement4 = dbcon.createStatement();
					String genrequery = "SELECT genre_id from genres_in_movies where movie_id="+movieID;
					ResultSet genreresult = statement4.executeQuery(genrequery);
					out.println("<div class='genres' style='padding:10px;text-align:left;'>");
					while(genreresult.next()){
						int genreID = genreresult.getInt("genre_id");
						Statement statement5 = dbcon.createStatement();
						String genrenamequery = "SELECT name from genres where id="+genreID;
						ResultSet genrenameresult = statement5.executeQuery(genrenamequery);
						genrenameresult.next();
						String genrename = genrenameresult.getString("name");
						out.println("<span class='genres_list' style='text-align:left;'>"+genrename+"</span>");
					}
					out.println("</div>");
					out.println("</div></div>");
				}
			%>
		</div>
	</center>
			
</body>
<script type="text/javascript">
	$(".movie-card").click(function(){
		var link=$(this).attr("href");
		var url = window.location.href;
		url = url.substring(0, url.length - 6);
		url=url+link;
		location.replace(url);
	});
	function placeholder(source){
		$(source).attr("src",'placeholder-movie.png');
	}
	$("#logoHeading").click(function(){
		location.replace("/Fablix/home");
	});
</script>
</html>