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
				String starquery = "SELECT * from stars where id="+request.getParameter("id");
				ResultSet starresult = statement.executeQuery(starquery);
            	starresult.next();        		
				String starfn = starresult.getString("first_name") ;           		
				String starln = starresult.getString("last_name");
				java.sql.Date dbSqlDate = starresult.getDate("dob");
			    java.util.Date star_dob = new java.util.Date(dbSqlDate.getTime());
				String star_photo = starresult.getString("photo_url");
				Statement mov_statement = dbcon.createStatement();
				String movieof_stars = "SELECT movie_id from stars_in_movies where star_id="+request.getParameter("id");
				ResultSet movieresult = mov_statement.executeQuery(movieof_stars);
				out.println("<div class='row movie-card' style='padding:15px;width:100%' href='/movie?id="+request.getParameter("id")+"'><div class='poster' style='width:240px;height:240px;float:left;'><img src='"+star_photo+"' onerror='placeholder(this);' style='height:100%;width:100%;pointer:cursor;'></div><div style='position:absolute;margin-left:260px;'><div class='movieID' style='padding:10px;text-align:left;'>"+request.getParameter("id")+"</div><div class='movieTitles' style='padding:10px;text-align:left;'>"+starfn+" "+starln+"</div><div class='year' style='padding:10px;text-align:left;'>"+star_dob+"</div><div class='stars' style='padding:10px;text-align:left;'>");
				while(movieresult.next()){
					int movieID = movieresult.getInt("movie_id");
					PreparedStatement movname_statement  = dbcon.prepareStatement("Select title from movies where id=?");
					movname_statement.setInt(1,movieID);
					ResultSet getmovie_name = movname_statement.executeQuery();
					getmovie_name.next();
					String mov_name = getmovie_name.getString("title");
					out.println("<a class='stars_link' href='/Fablix/movie?id="+movieID+"' style='text-align:left;'>"+mov_name+"</a><br>");
				}
				out.println("</div></div></div>");
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