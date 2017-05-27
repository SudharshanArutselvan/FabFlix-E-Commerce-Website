<html>
<%@ page import="java.io.*,java.net.*,java.sql.*,javax.sql.*,java.text.*,java.util.*,javax.servlet.*,javax.servlet.http.*"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<head>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>FabFlix</title>
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
		#genresList,#metadata{
			width:620px;
		}
		@media only screen(max-width:650px){
			.movies-list{
				width:550px;
				display:inline-block;
			}
			#genresList,#metadata{
				width:550px;
			}
		}
		@media only screen(max-width:450px){
			.movies-list{
				width:100%;
				display:inline-block;
			}
			#genresList,#metadata{
				width:100%;
			}
		}
    </style>
    <% 
    	if(session.getAttribute("emp")==null) response.sendRedirect("/fabflix/employeeLogin");
    %>
    <script>
    	function placeholder(source){
			$(source).attr("src",'./images/placeholder-movie.png');
		}
    	if(window.location.pathname=="/fabflix/emplogin"){
    		location.replace("/fabflix/_dashboard");
    	}
    </script>
</head>
<body style="">
	<div id="mainHeading" class="row" style="">
		<div class="col-md-3" id="logoHeading" style="margin:21px 0px;left:0;cursor:pointer;">FabFlix</div>
		<!-- <form class="col-md-6"><input class="inputbox" id="topsearch" type="text" name="search" placeholder="Search" style="border-radius:10px;"></form> -->
		<div id="customerName" class="col-md-3" Style="margin:35px 0px;font-size:18px;float:right;"><span id="drop" style="cursor:pointer;"><%out.print(session.getAttribute("emp"));%><i class="material-icons" style="color:#4aa7f6;font-size:15px;">arrow_drop_down</i></span>
			<div id="nameDropDown" style="position:absolute;top:45px;right:10%;background-color:#FFF;border-radius:5px;box-shadow:3px 2px 22px #888;width:83%;cursor:pointer;display:none;">
				<div id="logoff" style="padding: 25px;box-shadow:1px 1px 6px #888;font-size:15px;">Logout</div>
			</div>
		</div>
	</div>
	<center>
		<div id="genresList" class="row" style="">
			<button type="button" id="addstar" class="btn btn-default" style="margin: 25px 20px 0px;width:140px;">Enter new star</button>
			<button type="button" id="meta" class="btn btn-default" style="margin: 25px 20px 0px;width:140px;">Metadata</button>
			<button type="button" id="addmovie" class="btn btn-default" style="margin: 25px 20px 0px;width:140px;">Enter new movie</button>
		</div><br>
		<div class="row starIns" style="margin:20px;">
			<form class="row">
				<label style="font-size:18px;">First name</label><br>
				<input class="inputbox" id="fname" type="text" name="fname" placeholder="" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;"><br>
				<label style="font-size:18px;">Last name*</label><br>
				<input class="inputbox" id="lname" type="text" name="lname" placeholder="" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;" required><br>
				<label style="font-size:18px;">DOB</label><br>
				<input class="inputbox" id="dob" type="text" name="dob" placeholder="YYYY-MM-DD" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;"><br>
				<label style="font-size:18px;">Photo URL</label><br>
				<input class="inputbox" id="photo" type="text" name="photo" placeholder="Director" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;"><br>
				<button id="insert" type="button" class="btn btn-default" style="margin: 25px 20px 0px;width:140px;">Insert</button>
			</form>
		</div>
		<div id="metadata" style='margin:40px;'></div>
		<div class="row movIns" style="margin:20px;">
			<form class="row">
				<label style="font-size:18px;">Title*</label><br>
				<input class="inputbox" id="title" type="text" name="title" placeholder="" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;"><br>
				<label style="font-size:18px;">Year*</label><br>
				<input class="inputbox" id="year" type="text" name="year" placeholder="YYYY" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;"><br>
				<label style="font-size:18px;">Director*</label><br>
				<input class="inputbox" id="director" type="text" name="director" placeholder="" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;"><br>
				<label style="font-size:18px;">Banner URL</label><br>
				<input class="inputbox" id="b_photo" type="text" name="bannerurl" placeholder="" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;"><br>
				<label style="font-size:18px;">Trailer URL</label><br>
				<input class="inputbox" id="t_url" type="text" name="trailerurl" placeholder="" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;"><br>
				<label style="font-size:18px;">Star First Name</label><br>
				<input class="inputbox" id="star_fname" type="text" name="star" placeholder="" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;"><br>
				<label style="font-size:18px;">Star Last Name*</label><br>
				<input class="inputbox" id="star_lname" type="text" name="star" placeholder="" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;"><br>
				<label style="font-size:18px;">Genre*</label><br>
				<input class="inputbox" id="genre" type="text" name="genre" placeholder="" style="border-radius:10px;width:30%;text-align:left;margin-top:10px;"><br>
				<button id="insertMovie" type="button" class="btn btn-default" style="margin: 25px 20px 0px;width:140px;">Insert</button>
			</form>
		</div>
	</center>
</body>
<script src="./js/links.js" type="text/javascript"></script>
<script src="./js/pagination.js" type="text/javascript"></script>
<script type="text/javascript">
	$(".starIns").hide();
	$(".movIns").hide();
	$("#metadata").hide();
	var m=0;
	if(document.cookie.substring(9)=="") document.cookie = "username="+$("#customerName").text();
	$("#sortOptions").change(function(){
		var val = $("#sortOptions option:selected").attr("value");
	    location.replace("/fabflix/home?sort="+val);
	});
	$('#topsearch').keydown(function(event){ 
	    var keyCode = (event.keyCode ? event.keyCode : event.which);   
	    if (keyCode == 13) {
	        var value=$('#topsearch').val();
	        var url = window.location.href;
			var loc=window.location.pathname;
			var get=window.location.search;
			location.replace("/fabflix/result?search="+value);
	    }
	});
	$("#addstar").click(function(){
		$(".starIns").toggle();
		$("#metadata").hide();
		$(".movIns").hide();
	});
	$("#meta").click(function(){
		$(".starIns").hide();
		$(".movIns").hide();
		if(m>0) $("#metadata").toggle();
		else{
			$.ajax({
			    url: "/fabflix/metadata",
				method: "GET"
			}).done(function(msg) {
				console.log(msg);
				$("#metadata").show();
				$("#metadata").html(msg);
			  	m++;
			});
		}
	})
	$("#addmovie").click(function(){
		$(".starIns").hide();
		$("#metadata").hide();
		$(".movIns").toggle();
	});
	// Validates that the input string is a valid date formatted as "mm/dd/yyyy"
	function isValidDate(dateString)
	{
	    // First check for the pattern
	    if(!/^\d{4}\-\d{1,2}\-\d{1,2}$/.test(dateString))
	        return false;

	    // Parse the date parts to integers
	    var parts = dateString.split("-");
	    var day = parseInt(parts[2], 10);
	    var month = parseInt(parts[1], 10);
	    var year = parseInt(parts[0], 10);
	    
	    // Check the ranges of month and year
	    if(year < 1000 || year > 3000 || month == 0 || month > 12)
	        return false;

	    var monthLength = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];
	    // Adjust for leap years
	    if(year % 400 == 0 || (year % 100 != 0 && year % 4 == 0))
	        monthLength[1] = 29;
	    // Check the range of the day
	    return day > 0 && day <= monthLength[month - 1];
	};
	$("#insert").click(function(){
		var fname=$("#fname").val();
		var lname=$("#lname").val();
		var dob=$("#dob").val();
		var p_url=$("#photo").val();
		var x=1;
		if(dob=="") x=0;
		if(lname=="") alert("Please don't leave last name empty.\nIf star has only one name enter it as last name.");
		else if(!isValidDate(dob) && x==1) alert("Date format is wrong! Please enter as given.");
		else{
			console.log(fname+" "+lname+" "+dob+" "+p_url);
			$.ajax({
			    url: "/fabflix/insertStar",
				method: "GET",
			    data:{"fname":fname,"lname":lname,"DOB":dob,"url":p_url}
			}).done(function(msg) {
				console.log(msg);
				if(msg=="Success"){
					console.log("Star Inserted");
				}
			  	alert(msg);
			});
		}
	});
	$("#insertMovie").click(function(){
		var title=$("#title").val();
		var year=$("#year").val();
		var director=$("#director").val();
		var b_url=$("#b_photo").val();
		var t_url=$("#t_url").val();
		var star_fname=$("#star_fname").val();
		var star_lname=$("#star_lname").val();
		var genre=$("#genre").val();
		var fulldate=year+"-01-10";
		var properyear=parseInt(year);
		console.log(title+" "+properyear+" "+director+" "+b_url+" "+t_url+" "+star_fname+" "+star_lname+" "+genre);
		if(title=="") alert("Please enter the title of the movie empty.");
		else if(director=="") alert("Please enter the director name.");
		else if(star_lname=="") alert("Please don't leave last name empty.\nIf star has only one name enter it as last name.");
		else if(genre=="") alert("Please enter the Genre name.");
		else if(!isValidDate(fulldate)) alert("Please enter a valid year.");
		else{
			$.ajax({
			    url: "/fabflix/addMovie",
				method: "GET",
			    data:{"title":title,"year":properyear,"director":director,"b_url":b_url,"t_url":t_url,"star_fname":star_fname,"star_lname":star_lname,"genre":genre}
			}).done(function(msg) {
				console.log(msg);
				var splits=msg.split("|");
				var outString='';
				for(var j=0;j<splits.length;j++){
					if(splits[j]!=""){
						outString+=splits[j];
						if(j>0) outString+="\n";
					}
				}
				alert(outString);
			});
			$("form").find("input").val("");
		}
	});
</script>
</html>