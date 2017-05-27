<html>
<%@ page import="java.io.*,java.net.*,java.sql.*,javax.sql.*,java.text.*,java.util.*,javax.servlet.*,javax.servlet.http.*"%>
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
			<form class="row">
				<label style="font-size:18px;">Search by movie name</label><br>
				<input class="inputbox" id="movieName" type="text" name="search" placeholder="Search" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;"><br>
				<label style="font-size:18px;">Search by year</label><br>
				<input class="inputbox" id="year" type="text" name="year" placeholder="YYYY" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;margin-top:10px;"><br>
				<label style="font-size:18px;">Search by star name</label><br>
				<input class="inputbox" id="star" type="text" name="star_name" placeholder="Star name" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;"><br>
				<label style="font-size:18px;">Search by Director</label><br>
				<input class="inputbox" id="director" type="text" name="star_name" placeholder="Director" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;"><br>
				<button id="advSearch" type="button" class="btn btn-default" style="margin: 25px 20px 0px;width:140px;">Search</button>
			</form>
		</div>
	</center>
</body>
<script src="./js/links.js" type="text/javascript"></script>
<script src="./js/pagination.js" type="text/javascript"></script>
<script type="text/javascript">
	var movie,year,star,director;
	$("#advSearch").click(function(){
		var movie=$("#movieName").val();
		var year=$("#year").val();
		var star=$("#star").val();
		var director=$("#director").val();
		console.log(movie+" "+year+" "+star);
		var url="/fabflix/result?"
		var c=0;
		if(movie){
			url+="search="+movie;
			c++;
		}
		if(year){
			if(c>0) url+="&";
			url+="year="+year;
			c++;
		}
		if(star){
			if(c>0) url+="&";
			url+="star="+star;
			c++;
		}
		if(director){
			if(c>0) url+="&";
			url+="director="+director;
			c++;
		}
		if(c==0) alert("Please enter some value to search");
		else location.replace(url);
	});
</script>