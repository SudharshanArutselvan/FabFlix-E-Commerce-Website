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
			width:960px;
		}
		@media only screen(max-width:1000px){
			.movies-list{
				width:750px;
			}
		}
		@media only screen(max-width:800px){
			.movies-list{
				width:750px;
			}
		}
		@media only screen(max-width:600px){
			.movies-list{
				width:550px;
			}
		}
		@media only screen(max-width:450px){
			.movies-list{
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
			<form class="row">
				<label style="font-size:18px;">Search by movie name</label><br>
				<input class="inputbox" id="movieName" type="text" name="search" placeholder="Search" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;"><br>
				<div style="width:100%;padding:20px;"> 
				<% 
					String user = "user";
					String pw = "vidhya567";
					String url = "jdbc:mysql://localhost:3306/moviedb";
					Class.forName("com.mysql.jdbc.Driver").newInstance();
					Connection dbcon  = DriverManager.getConnection(url, user, pw);
					Statement statement = dbcon.createStatement();
					String genquery = "SELECT name from genres ORDER BY name";
					ResultSet genresult = statement.executeQuery(genquery);
					int i=1;
					while(genresult.next())
					{  
						
						String genname= genresult.getString("name");
						
						out.println("<div class='col-xs-3' style='text-align:left;'><input class = 'gen_check_box' type = 'checkbox' name='gen_check_box' value='"+genname+"'><label style='padding:7px;'>"+genname+"</label></div>");
						i++;

					}
				%>
				</div>
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
<script type="text/javascript">
	$("#advSearch").click(function(){
		var movie=$("#movieName").val();
		var year=$("#year").val();
		var star=$("#star").val();
		var director=$("#director").val();
		var genres=[];
		var i=0;
		$(".gen_check_box:checked").each ( function() {
	   		genres[i]= $(this).val();
	   		i++;
	 	});
		console.log(movie+" "+year+" "+star);
	});
	$("#logoHeading").click(function(){
		location.replace("/Fablix/home");
	});
</script>