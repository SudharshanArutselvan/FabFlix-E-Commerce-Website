<html>
<%@ page import="java.io.*,java.net.*,java.sql.*,javax.sql.*,java.text.*,java.util.*,javax.servlet.*,javax.servlet.http.*,javax.naming.InitialContext,javax.naming.Context,javax.sql.DataSource"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<head>
	<title>FabFlix</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="icon" type="image/jpg" href="./images/icon.jpg" />
	<link rel="stylesheet" type="text/css" href="./css/main.css">
	<link rel="stylesheet" type="text/css" href="./css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css" href="./css/icon.css">
	<script src="./js/jquery-3.1.1.min.js"></script>
	<script src="./js/bootstrap.min.js"></script>
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
    	if(session.getAttribute("name")==null) response.sendRedirect("/fabflix/");
    %>
    <script type="text/javascript">
    	function placeholder(source){
			$(source).attr("src",'placeholder-movie.png');
		}
    </script>
</head>
<body style="">
	<div id="mainHeading" class="row" style="">
		<div class="col-md-3" id="logoHeading" style="margin:21px 0px;left:0;cursor:pointer;">FabFlix</div>
		<form class="col-md-6" action="/fabflix/result" method="GET"><input class="inputbox" id="topsearch" type="text" name="search" placeholder="Search" style="border-radius:10px;">
			<div id="searchDrop" style="position:absolute;top:72px;right:0px;border-radius:5px;width:100%;cursor:pointer;padding:1px 15px;">
				
			</div>
		</form>
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
				// String user = "testuser";
				// String pw = "testpass";
				// String url = "jdbc:mysql://localhost:3306/moviedb";
				// Class.forName("com.mysql.jdbc.Driver").newInstance();
				// Connection dbcon  = DriverManager.getConnection(url, user, pw);
				// Statement statement = dbcon.createStatement();
				
				Context initCtx = new InitialContext();
	            if (initCtx == null)
	                out.println("initCtx is NULL");
	            Context envCtx = (Context) initCtx.lookup("java:comp/env");
	            if (envCtx == null)
	                out.println("envCtx is NULL");
	            // Look up our data source
	            DataSource ds = (DataSource) envCtx.lookup("jdbc/moviedb");

	            // the following commented lines are direct connections without pooling
	            //Class.forName("org.gjt.mm.mysql.Driver");
	            //Class.forName("com.mysql.jdbc.Driver").newInstance();
	            //Connection dbcon = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);

	            if (ds == null)
	                out.println("ds is null.");
	            Connection dbcon = ds.getConnection();
	            if (dbcon == null)
	                out.println("dbcon is null.");

				// String moviequery = "SELECT * from movies where id="+request.getParameter("id");
				// ResultSet movieresult = statement.executeQuery(moviequery);

	            int getMovie = Integer.parseInt(request.getParameter("id"));
				PreparedStatement moviequery = dbcon.prepareStatement("SELECT * from movies where id=?");
				moviequery.setInt(1,getMovie);
				ResultSet movieresult = moviequery.executeQuery();

				while(movieresult.next())
				{  
					int movieID = movieresult.getInt("id");
					String moviename = movieresult.getString("title");
					String banner_url = movieresult.getString("banner_url");
					int year = movieresult.getInt("year");
					String director = movieresult.getString("director");
					String trailer_url = movieresult.getString("trailer_url");

					out.println("<div class='row movie-card' style='padding:15px;width:100%' movid="+movieID+" href='/fabflix/movie?id="+movieID+"'><div class='cartPoster' style='width:240px;float:left;'><div class='poster' style='width:240px;height:240px;cursor:pointer;'><img src='"+banner_url+"' onerror='placeholder(this)' style='height:100%;width:100%;pointer:cursor;'></div><div class='addToCart' style='width:40%;background-color:#4aa7f6;padding:4px;margin-top:10px;height:30px;border-radius:5px;color:#FFF;cursor:pointer;'>Add to Cart</div></div><div style='margin-left:260px;'><div class='movieID' style='padding:10px;text-align:left;'>Movie ID : "+movieID+"</div><div class='movieTitles' style='padding:10px;text-align:left;'> Movie : "+moviename+"</div><div class='year' style='padding:10px;text-align:left;'>Year : "+year+"</div><div class='director' style='padding:10px;text-align:left;'>Director : "+director+"</div>");

					//Statement statement2 = dbcon.createStatement();
					//String starquery = "SELECT star_id from stars_in_movies where movie_id="+movieID;
					//ResultSet starresult = statement2.executeQuery(starquery);

					PreparedStatement starquery  = dbcon.prepareStatement("SELECT star_id from stars_in_movies where movie_id=?");
					starquery.setInt(1,movieID);
					ResultSet starresult = starquery.executeQuery();

					out.println("<div class='stars' style='padding:10px;text-align:left;'>Stars :");
					while(starresult.next()){
						int starID = starresult.getInt("star_id");
						//Statement statement3 = dbcon.createStatement();
						//String starnamequery = "SELECT * from stars where id="+starID;
						//ResultSet starnameresult = statement3.executeQuery(starnamequery);

						PreparedStatement starnamequery  = dbcon.prepareStatement("SELECT * from stars where id=?");
						starnamequery.setInt(1,starID);
						ResultSet starnameresult = starnamequery.executeQuery();

						starnameresult.next();
						String starname = starnameresult.getString("first_name")+" "+starnameresult.getString("last_name");
						out.println("<a class='stars_link' href='/fabflix/star?id="+starID+"' style='text-align:left;'>"+starname+"</a>");
						starnamequery.close();
						starnameresult.close();
					}
					out.println("</div>");
					//Statement statement4 = dbcon.createStatement();
					//String genrequery = "SELECT genre_id from genres_in_movies where movie_id="+movieID;
					//ResultSet genreresult = statement4.executeQuery(genrequery);

					PreparedStatement genrequery  = dbcon.prepareStatement("SELECT genre_id from genres_in_movies where movie_id=?");
					genrequery.setInt(1,movieID);
					ResultSet genreresult = genrequery.executeQuery();

					out.println("<div class='genres' style='padding:10px;text-align:left;'>Genres : ");
					while(genreresult.next()){
						int genreID = genreresult.getInt("genre_id");
						//Statement statement5 = dbcon.createStatement();
						//String genrenamequery = "SELECT name from genres where id="+genreID;
						//ResultSet genrenameresult = statement5.executeQuery(genrenamequery);

						PreparedStatement genrenamequery  = dbcon.prepareStatement("SELECT name from genres where id=?");
						genrenamequery.setInt(1,genreID);
						ResultSet genrenameresult = genrenamequery.executeQuery();

						genrenameresult.next();
						String genrename = genrenameresult.getString("name");
						out.println("<a class='genres_list' style='text-align:left;' href='/fabflix/genre?genre="+genrename+"' >"+genrename+"</a>");
						genrenamequery.close();
						genrenameresult.close();
					}
					out.println("</div><div class='prices' style='padding:10px;text-align:left;'>Price : $19.99</div>");
					out.println("<a href="+trailer_url+"' style='display:block;padding:10px;text-align:left;'>"+"view trailer"+"</a>");
					out.println("</div></div>");
					genrequery.close();
					starquery.close();
					starresult.close();
					genreresult.close();
				}
				movieresult.close();
				moviequery.close();
				dbcon.close();
			%>
		</div>
	</center>
			
</body>
<script src="./js/links.js" type="text/javascript"></script>
<script type="text/javascript">
</script>
</html>