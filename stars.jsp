<html>
<%@ page import="java.io.*,java.net.*,java.sql.*,javax.sql.*,java.text.*,java.util.*,javax.servlet.*,javax.servlet.http.*"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<head>
	<title>Fablix</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="icon" type="image/jpg" href="./images/icon.jpg" />
	<link rel="stylesheet" type="text/css" href="./css/main.css">
	<link rel="stylesheet" type="text/css" href="./css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="./css/icon.css">
	<script src="./js/bootstrap.min.js"></script>
	<script src="./js/jquery-3.1.1.min.js"></script>
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
    <% 
    	if(session.getAttribute("name")==null) response.sendRedirect("index.jsp");
    %>
    <script type="text/javascript">
    	function placeholder(source){
			$(source).attr("src",'./images/placeholder-movie.png');
		}
    </script>
</head>
<body style="">
	<div id="mainHeading" class="row" style="">
		<div class="col-md-3" id="logoHeading" style="margin:21px 0px;left:0;cursor:pointer;">Fablix</div>
		<form class="col-md-6"><input class="inputbox" type="text" id="topsearch" name="search" placeholder="Search" style="border-radius:10px;"></form>
		<div id="customerName" class="col-md-3" Style="margin:35px 0px;font-size:18px;"><span id="drop" style="cursor:pointer;"><%out.print(session.getAttribute("name"));%><i class="material-icons" style="color:#4aa7f6;font-size:15px;">arrow_drop_down</i></span>
			<div id="nameDropDown" style="position:absolute;top:45px;right:10%;background-color:#FFF;border-radius:5px;box-shadow:3px 2px 22px #888;width:83%;cursor:pointer;display:none;">
				<div id="cart" style="padding: 25px;box-shadow:1px 1px 6px #888;font-size:15px;">Shopping Cart</div>
				<div id="logoff" style="padding: 25px;box-shadow:1px 1px 6px #888;font-size:15px;">Logout</div>
			</div>
		</div>
	</div>
	<center>
		<div id="genresList" class="row" style="">
			<button type="button" id="browseMovie" class="btn btn-default" style="margin: 25px 20px 0px;width:140px;">Browse by Movies</button>
			<button type="button" id="browsegenre" class="btn btn-default" style="margin: 25px 20px 0px;width:140px;">Browse by Genres</button>
			<button type="button" id="searchMovie" class="btn btn-default" style="margin: 25px 20px 0px;width:140px;">Search Movies</button>
		</div><br>
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
            	int starID=starresult.getInt("id");      		
				String starfn = starresult.getString("first_name") ;           		
				String starln = starresult.getString("last_name");
				java.sql.Date dbSqlDate = starresult.getDate("dob");
			    java.util.Date star_dob = new java.util.Date(dbSqlDate.getDate());
				String star_photo = starresult.getString("photo_url");
				Statement mov_statement = dbcon.createStatement();
				SimpleDateFormat ft = new SimpleDateFormat ("dd.MM.yyyy");
				String displayDate=ft.format(star_dob);
				String movieof_stars = "SELECT movie_id from stars_in_movies where star_id="+request.getParameter("id");
				out.println("<div class='row movie-card' style='padding:15px;width:100%' movid="+starID+" href='/Fablix/star?id="+starID+"'><div class='cartPoster' style='width:240px;float:left;'><div class='poster' style='width:240px;height:240px;cursor:pointer;'><img src='"+star_photo+"' onerror='placeholder(this)' style='height:100%;width:100%;pointer:cursor;'></div></div><div style='margin-left:260px;'><div class='movieID' style='padding:10px;text-align:left;'>Star ID : "+starID+"</div><div class='movieTitles' style='padding:10px;text-align:left;'> Star Name : "+starfn+" "+starln+"</div><div class='year' style='padding:10px;text-align:left;'>DOB : "+displayDate+"</div><div class='movies' style='padding:10px;text-align-left;'>Movies:");
				ResultSet movieresult = mov_statement.executeQuery(movieof_stars);
				while(movieresult.next()){
					int movieID = movieresult.getInt("movie_id");
					PreparedStatement movname_statement  = dbcon.prepareStatement("Select title from movies where id=?");
					movname_statement.setInt(1,movieID);
					ResultSet getmovie_name = movname_statement.executeQuery();
					getmovie_name.next();
					String mov_name = getmovie_name.getString("title");
					out.println("<a class='stars_link' href='/Fablix/movie?id="+movieID+"' style='text-align:left;display:block;'>"+mov_name+"</a>");
				}
				out.println("</div><div class='prices' style='padding:10px;text-align:left;'>Price : $19.99</div></div></div>");
			%>
		</div>
	</center>
			
</body>
<script src="./js/links.js" type="text/javascript"></script>
<script type="text/javascript">
$('#topsearch').keydown(function(event){ 
	    var keyCode = (event.keyCode ? event.keyCode : event.which);   
	    if (keyCode == 13) {
	        var value=$('#topsearch').val();
	        var url = window.location.href;
			var loc=window.location.pathname;
			var get=window.location.search;
			url=url.substring(0,url.length-loc.length-get.length)+"/Fablix/result?search="+value;
			window.open(url,"_self");
	    }
	});
</script>
</html>