<html>
<%@ page import="java.io.*,java.net.*,java.sql.*,javax.sql.*,java.text.*,java.util.*,javax.servlet.*,javax.servlet.http.*"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<head>
	<title>Fablix</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="icon" type="image/jpg" href="./images/icon.jpg" />
	<link rel="stylesheet" type="text/css" href="./css/main.css">
	<link rel="stylesheet" type="text/css" href="./css/bootstrap.min.css">
	<script src="./js/jquery-3.1.1.min.js"></script>
	<script src="./js/bootstrap.min.js"></script>
	<link rel="stylesheet" type="text/css" href="./css/icon.css">
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
    <script>
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
			<% 
				String user = "user";
				String pw = "vidhya567";
				String url = "jdbc:mysql://localhost:3306/moviedb";
				Class.forName("com.mysql.jdbc.Driver").newInstance();
				Connection dbcon  = DriverManager.getConnection(url, user, pw);
				String sortType=request.getParameter("sort");
				int sort=1;
				if(sortType==null){}
				else sort=Integer.parseInt(sortType);
			%>
			<button type="button" id="browseMovie" class="btn btn-default" style="margin: 25px 20px 0px;width:140px;">Browse by Movies</button>
			<button type="button" id="browsegenre" class="btn btn-default" style="margin: 25px 20px 0px;width:140px;">Browse by Genres</button>
			<button type="button" id="searchMovie" class="btn btn-default" style="margin: 25px 20px 0px;width:140px;">Search Movies</button>
		</div><br>
		<label class="sortDisplay">Sort by: </label>
		<select id='sortOptions' name='sort' val=<% out.print(sort); %> style="margin-bottom:15px;">
			<option value="1">Title: Ascending</option>
			<option value="2">Title: Descending</option>
			<option value="3">Year: Ascending</option>
			<option value="4">Year: Descending</option>
			<option value="5">ID: Ascending</option>
			<option value="6">ID: Descending</option>
		</select>
		<label class="sortDisplay">Display per page: </label>
		<select id='displayOptions' name='display'>
			<option value="10">10</option>
			<option value="20">20</option>
			<option value="25">25</option>
			<option value="50">50</option>
		</select><br>
		<button type="button" id="" class="btn btn-default prev disabled" style="">Prev</button>
		<div class="numbers" style="display:inline;padding:15px;"></div>
		<button type="button" id="" class="btn btn-default next" style="">Next</button>
		<div class="row movies-list" style="margin:20px;">
			<% 
				String mov_title = request.getParameter("search");
				String mov_year =	request.getParameter("year");
				String mov_director = request.getParameter("director");
				String mov_star =	request.getParameter("star");
				String query = "SELECT * FROM movies WHERE";
				Statement movie_statement = dbcon.createStatement();
				int c=0;
				if(mov_title!=null){ query+= " title LIKE '%"+mov_title+"%'"; c++; }
				if(mov_year!=null)
				{
					if(c>0) query+=" and";
	                int year=Integer.parseInt(mov_year);
					query+=" year="+year;
					c++;
				}
				if(mov_director!=null){ 
					if(c>0) query+=" and";
					query+=" director LIKE '%"+mov_director+"%'";
					c++;
				}
				String appendSort=" order by title";
				switch(sort){
					case 2: appendSort=" order by title desc";
					break;
					case 3: appendSort=" order by year";
					break;
					case 4: appendSort=" order by year desc";
					break;
					case 1: appendSort=" order by title";
					break;
					case 5: appendSort=" order by id";
					break;
					case 6: appendSort=" order by id desc";
					break;
					default: appendSort=" order by title";
				}
				if(mov_star!=null)
				{	
					int res;
					String[] star_name = mov_star.split(" ");
					String first_nametag="";
					String last_nametag="";
					if(star_name.length >= 2)
					{
						first_nametag = star_name[0];
						last_nametag  = star_name[1];
						res = 0;
					}
					else 
					{
	                    first_nametag = star_name[0];
	                    last_nametag  = star_name[0];
						res = 1;
					}
	                                String query2=query;
	                                if(c>0) query2+=" and";
                                    query2+=" id IN (Select distinct(movie_id) from stars_in_movies where star_id IN (Select id from stars where first_name LIKE '%"+first_nametag+"%' or last_name LIKE '%"+last_nametag+"%'))"+appendSort;
	                                ResultSet movieresult = movie_statement.executeQuery(query2); 
	                                int keepcount=0;
	                                while(movieresult.next())
	                                {
	                                    int movieID = movieresult.getInt("id");
										String moviename = movieresult.getString("title");
										String banner_url = movieresult.getString("banner_url");
										int year = movieresult.getInt("year");
										String director = movieresult.getString("director");
										out.println("<div class='row movie-card hidden' style='padding:15px;width:100%' movid="+movieID+" href='/Fablix/movie?id="+movieID+"'><div class='cartPoster' style='width:240px;float:left;'><div class='poster' style='width:240px;height:240px;cursor:pointer;'><img src='"+banner_url+"' onerror='placeholder(this)' style='height:100%;width:100%;pointer:cursor;'></div><div class='addToCart' style='width:40%;background-color:#4aa7f6;padding:4px;margin-top:10px;height:30px;border-radius:5px;color:#FFF;cursor:pointer;'>Add to Cart</div></div><div style='margin-left:260px;'><div class='movieID' style='padding:10px;text-align:left;'>Movie ID : "+movieID+"</div><div class='movieTitles' style='padding:10px;text-align:left;'> Movie : <a href='/Fablix/movie?id="+movieID+"'>"+moviename+"</a></div><div class='year' style='padding:10px;text-align:left;'>Year : "+year+"</div><div class='director' style='padding:10px;text-align:left;'>Director : "+director+"</div>");
										Statement statement2 = dbcon.createStatement();
										String starquery = "SELECT star_id from stars_in_movies where movie_id="+movieID;
										ResultSet starresult = statement2.executeQuery(starquery);
										out.println("<div class='stars' style='padding:10px;text-align:left;'>Stars :");
										while(starresult.next()){
											int starID = starresult.getInt("star_id");
											Statement statement3 = dbcon.createStatement();
											String starnamequery = "SELECT * from stars where id="+starID;
											ResultSet starnameresult = statement3.executeQuery(starnamequery);
											starnameresult.next();
											String starname = starnameresult.getString("first_name")+" "+starnameresult.getString("last_name");
											out.println("<a class='stars_link' href='/Fablix/star?id="+starID+"' style='text-align:left;display: block;'>"+starname+"</a>");
										}
										out.println("</div>");
										Statement statement4 = dbcon.createStatement();
										String genrequery = "SELECT genre_id from genres_in_movies where movie_id="+movieID;
										ResultSet genreresult = statement4.executeQuery(genrequery);
										out.println("<div class='genres' style='padding:10px;text-align:left;'>Genres : ");
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
										keepcount++;
	                                }
	                                if(keepcount==0) out.println("No matching records found!");
	            }
	            else
	            {
	        		query+=appendSort;
	            	ResultSet movieresult = movie_statement.executeQuery(query);
	            	int keepcount=0;
	                while(movieresult.next())
	                {
	                    int movieID = movieresult.getInt("id");
						String moviename = movieresult.getString("title");
						String banner_url = movieresult.getString("banner_url");
						int year = movieresult.getInt("year");
						String director = movieresult.getString("director");
						out.println("<div class='row movie-card hidden' style='padding:15px;width:100%' movid="+movieID+" href='/Fablix/movie?id="+movieID+"'><div class='cartPoster' style='width:240px;float:left;'><div class='poster' style='width:240px;height:240px;cursor:pointer;'><img src='"+banner_url+"' onerror='placeholder(this)' style='height:100%;width:100%;pointer:cursor;'></div><div class='addToCart' style='width:40%;background-color:#4aa7f6;padding:4px;margin-top:10px;height:30px;border-radius:5px;color:#FFF;cursor:pointer;'>Add to Cart</div></div><div style='margin-left:260px;'><div class='movieID' style='padding:10px;text-align:left;'>Movie ID : "+movieID+"</div><div class='movieTitles' style='padding:10px;text-align:left;'> Movie : <a href='/Fablix/movie?id="+movieID+"'>"+moviename+"</a></div><div class='year' style='padding:10px;text-align:left;'>Year : "+year+"</div><div class='director' style='padding:10px;text-align:left;'>Director : "+director+"</div>");
						Statement statement2 = dbcon.createStatement();
						String starquery = "SELECT star_id from stars_in_movies where movie_id="+movieID;
						ResultSet starresult = statement2.executeQuery(starquery);
						out.println("<div class='stars' style='padding:10px;text-align:left;'>Stars :");
						while(starresult.next()){
							int starID = starresult.getInt("star_id");
							Statement statement3 = dbcon.createStatement();
							String starnamequery = "SELECT * from stars where id="+starID;
							ResultSet starnameresult = statement3.executeQuery(starnamequery);
							starnameresult.next();
							String starname = starnameresult.getString("first_name")+" "+starnameresult.getString("last_name");
							out.println("<a class='stars_link' href='/Fablix/star?id="+starID+"' style='text-align:left;display: block;'>"+starname+"</a>");
						}
						out.println("</div>");
						Statement statement4 = dbcon.createStatement();
						String genrequery = "SELECT genre_id from genres_in_movies where movie_id="+movieID;
						ResultSet genreresult = statement4.executeQuery(genrequery);
						out.println("<div class='genres' style='padding:10px;text-align:left;'>Genres : ");
						while(genreresult.next()){
							int genreID = genreresult.getInt("genre_id");
							Statement statement5 = dbcon.createStatement();
							String genrenamequery = "SELECT name from genres where id="+genreID;
							ResultSet genrenameresult = statement5.executeQuery(genrenamequery);
							genrenameresult.next();
							String genrename = genrenameresult.getString("name");
							out.println("<span class='genres_list' style='text-align:left;'>"+genrename+"</span>");
						}
						out.println("</div><div class='prices' style='padding:10px;text-align:left;'>Price : $19.99</div>");
						out.println("</div></div>");
						keepcount++;
	                }
	                if(keepcount==0) out.println("No matching records found!");

	            }
			%>
		</div>
		<button type="button" id="" class="btn btn-default prev disabled" style="">Prev</button>
		<div class="numbers" style="display:inline;padding:15px;"></div>
		<button type="button" id="" class="btn btn-default next" style="">Next</button>
	</center>
			
</body>
<script src="./js/links.js" type="text/javascript"></script>
<script src="./js/pagination.js" type="text/javascript"></script>
<script type="text/javascript">
	$("#sortOptions").change(function(){
		var val = $("#sortOptions option:selected").attr("value");
	    window.open(window.location.href.split("&")[0]+"&sort="+val,"_self");
	});
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