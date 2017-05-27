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
		.popup-card{
			padding: 15px;
		    width: 60% !important;
		    display: inline-block;
		    float: left;
		    position: absolute;
		    left: 0;
		    margin-left: 20%;
		    background: #FFF;
		    box-shadow: 1px 1px 6px #888;
		}
    </style>
    <% 
    	if(session.getAttribute("name")==null) response.sendRedirect("/fabflix/");
    %>
    <script type="text/javascript">
    	function placeholder(source){
			$(source).attr("src",'./images/placeholder-movie.png');
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
		<label class="sortDisplay">Sort by: </label>
		<select id='sortOptions' name='sort' val=<% request.getParameter("sort"); %> style="margin-bottom:15px;">
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
		<button type="button" class="btn btn-default prev disabled" style="opacity:1;">Prev</button>
		<div class="numbers" style="display:inline;padding:15px;"></div>
		<button type="button" class="btn btn-default next" style="opacity:1;">Next</button>
		<div style="width:100%;padding:20px;"> 
			<% 
				// String user = "testuser";
				// String pw = "testpass";
				// String url = "jdbc:mysql://localhost:3306/moviedb";
				// Class.forName("com.mysql.jdbc.Driver").newInstance();
				// Connection dbcon  = DriverManager.getConnection(url, user, pw);

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
				
				Statement statement = dbcon.createStatement();
				String genquery = "SELECT name from genres ORDER BY name";
				ResultSet genresult = statement.executeQuery(genquery);
				int i=1;
				String sortType=request.getParameter("sort");
				String displayType=request.getParameter("display");
				String pagenum=request.getParameter("pagenum");
				int sort=1;
				int disp=10;
				int currPage=1;
				if(sortType==null){}
				else sort=Integer.parseInt(sortType);
				if(displayType==null){}
				else disp=Integer.parseInt(displayType);
				if(pagenum==null){}
				else currPage=Integer.parseInt(pagenum);
				if(currPage<1) currPage=1;
				String genre=request.getParameter("genre");
				if(genre==null){
					genre = "Action";
				}
				Statement countStatement= dbcon.createStatement();
				String counts="select count(*) as count from movies where id in (select distinct(movie_id) from genres_in_movies where genre_id in (select id from genres where name='"+genre+"'));";
				ResultSet count = countStatement.executeQuery(counts);
				int totalCount=11384;
				if(count.next()){
					totalCount=count.getInt(1);
				}
				out.println("<select id='genreOptions' name='genres'>");
				while(genresult.next())
				{  
					String genname= genresult.getString("name");
					if(genname==genre) out.println("<option value='"+genname+"' selected='selected'>"+genname+"</option>");
					else out.println("<option value='"+genname+"'>"+genname+"</option>");
					i++;
				}
				out.println("</select>");
				out.println("<div class='titleGenre' style='padding:20px 20px 0px;font-size:20px;'>"+genre+"</div>");
				out.println("<div class='hidden' id='getValues' disp="+disp+" page="+currPage+" total="+totalCount+" genre="+genre+" sort="+sort+"></div>");
			%>
		</div>
		<div class="row movies-list" style="margin:20px;">
			<%
			try{
				//String moviequery = "SELECT * from movies where id IN (SELECT movie_id from genres_in_movies where genre_id IN (SELECT id from genres where name='"+genre+"'))";
				PreparedStatement moviequery = dbcon.prepareStatement("SELECT * from movies where id IN (SELECT movie_id from genres_in_movies where genre_id IN (SELECT id from genres where name=?)) order by ? limit ? offset ?");
				moviequery.setString(1,genre);
				switch(sort){
					case 2: moviequery.setString(2,"title desc");
					break;
					case 3: moviequery.setString(2,"year");
					break;
					case 4: moviequery.setString(2,"year desc");
					break;
					case 1: moviequery.setString(2,"title");
					break;
					case 5: moviequery.setString(2,"id");
					break;
					case 6: moviequery.setString(2,"id desc");
					break;
					default: moviequery.setString(2,"title");
				}
				currPage=(currPage-1)*disp;
				moviequery.setInt(3,disp);
				moviequery.setInt(4,currPage);
				//moviequery+=" limit "+disp+" offset "+currPage;
				//Statement statement6 = dbcon.createStatement();
				ResultSet movieresult = moviequery.executeQuery();
				while(movieresult.next()){
					int movieID=movieresult.getInt("id");
					String moviename = movieresult.getString("title");
					String banner_url = movieresult.getString("banner_url");
					int year = movieresult.getInt("year");
					String director = movieresult.getString("director");
					String trailer_url = movieresult.getString("trailer_url");
					out.println("<div class='row movie-card' style='padding:15px;width:100%' movid="+movieID+" href='/fabflix/movie?id="+movieID+"'><div class='cartPoster' style='width:240px;float:left;'><div class='poster' style='width:240px;height:240px;cursor:pointer;'><img src='"+banner_url+"' onerror='placeholder(this)' style='height:100%;width:100%;pointer:cursor;'></div><div class='addToCart' style='width:40%;background-color:#4aa7f6;padding:4px;margin-top:10px;height:30px;border-radius:5px;color:#FFF;cursor:pointer;'>Add to Cart</div></div><div style='margin-left:260px;'><div class='movieID' style='padding:10px;text-align:left;'>Movie ID : "+movieID+"</div><div class='movieTitles' style='padding:10px;text-align:left;'> Movie : <a class='movieTitle' href='/fabflix/movie?id="+movieID+"'>"+moviename+"</a></div><div class='year' style='padding:10px;text-align:left;'>Year : "+year+"</div><div class='director' style='padding:10px;text-align:left;'>Director : "+director+"</div>");
					PreparedStatement starquery = dbcon.prepareStatement("SELECT star_id from stars_in_movies where movie_id=?");
					starquery.setInt(1,movieID);
					ResultSet starresult = starquery.executeQuery();
					//Statement statement2 = dbcon.createStatement();
					//String starquery = "SELECT star_id from stars_in_movies where movie_id="+movieID;
					//ResultSet starresult = statement2.executeQuery(starquery);
					out.println("<div class='stars' style='padding:10px;text-align:left;'>Stars : ");
					while(starresult.next()){
						int starID = starresult.getInt("star_id");
						PreparedStatement starnamequery = dbcon.prepareStatement("SELECT * from stars where id=?");
						starnamequery.setInt(1,starID);
						ResultSet starnameresult = starnamequery.executeQuery();
						//Statement statement3 = dbcon.createStatement();
						//String starnamequery = "SELECT * from stars where id="+starID;
						//ResultSet starnameresult = statement3.executeQuery(starnamequery);
						starnameresult.next();
						String starname = starnameresult.getString("first_name")+" "+starnameresult.getString("last_name");
						out.println("<a class='stars_link' href='/fabflix/star?id="+starID+"' style='text-align:left;display:block;'>"+starname+"</a>");
						starnameresult.close();
						starnamequery.close();
					}
					out.println("</div>");
					PreparedStatement genrequery1 = dbcon.prepareStatement("SELECT genre_id from genres_in_movies where movie_id=?");
					genrequery1.setInt(1,movieID);
					ResultSet genreresult1 = genrequery1.executeQuery();
					//Statement statement4 = dbcon.createStatement();
					//String genrequery1 = "SELECT genre_id from genres_in_movies where movie_id="+movieID;
					//ResultSet genreresult1 = statement4.executeQuery(genrequery1);
					out.println("<div class='genres' style='padding:10px;text-align:left;'>Genres : ");
					while(genreresult1.next()){
						int genresid = genreresult1.getInt("genre_id");
						PreparedStatement genrenamequery = dbcon.prepareStatement("SELECT * from genres where id=?");
						genrenamequery.setInt(1,genresid);
						ResultSet genrenameresult = genrenamequery.executeQuery();
						//Statement statement5 = dbcon.createStatement();
						//String genrenamequery = "SELECT name from genres where id="+genresid;
						//ResultSet genrenameresult = statement5.executeQuery(genrenamequery);
						genrenameresult.next();
						String genrename = genrenameresult.getString("name");
						out.println("<span class='genres_list' style='text-align:left;'>"+genrename+"</span>");
						genrenamequery.close();
						genrenameresult.close();
					}
					out.println("</div><div class='prices' style='padding:10px;text-align:left;'>Price : $19.99</div>");
					out.println("<a class='trailerURL hidden' href="+trailer_url+"' style='display:block;padding:10px;text-align:left;'>view trailer</a></div></div>");
					starquery.close();
					starresult.close();
					genreresult1.close();
					genrequery1.close();
				}
				movieresult.close();
				moviequery.close();
				dbcon.close();
			}
			catch(java.lang.Exception e){
				out.println("Error:"+e.getMessage());
			}
			%>
		</div>
		<button type="button" id="" class="btn btn-default prev disabled" style="">Prev</button>
		<div class="numbers" style="display:inline;padding:15px;"></div>
		<button type="button" id="" class="btn btn-default next" style="">Next</button>
	</center>
			
</body>
<script src="./js/links.js" type="text/javascript"></script>
<script type="text/javascript">
	var pageDisplay=parseInt($("#getValues").attr("disp"));
	var pageNum=parseInt($("#getValues").attr("page"));
	var i;
	var genre=$("#getValues").attr("genre");
	// $(".movie-card").slice(0,pageDisplay).removeClass("hidden");
	var totalMovies=$("#getValues").attr("total");
	var type=$("#getValues").attr("sort");
	var totalPages=Math.ceil(totalMovies/pageDisplay);

	function writeNumbers(){
		$(window).scrollTop(0);
		if(pageNum>1) $(".prev").removeClass("disabled");
		if(totalPages==pageNum) $(".next").addClass("disabled");
		if(pageNum==1) $(".prev").addClass("disabled");
		if(totalPages>pageNum) $(".next").removeClass("disabled");
		var x,y;
		if(pageNum==1){
			x=pageNum; y=pageNum+5;
		}
		else if(pageNum==2){
			x=pageNum-1; y=pageNum+4;
		}
		else if(pageNum==totalPages){
			x=pageNum-4; y=pageNum+1;
		}
		else if(pageNum==totalPages-1){
			x=pageNum-3; y=pageNum+2;
		}
		else{
			x=pageNum-2;y=pageNum+3;
		}
		if(x<1) x=1;
		if(y>totalPages+1) y=totalPages+1;
		$(".numbers").empty();
		if(pageNum>3&&totalPages>6) $(".numbers").append("<span style='padding:0px 8px;cursor:pointer;' onclick='goToPage("+1+")'>"+1+"</span><span>...</span>");
		else if(totalPages==6&&x>1) $(".numbers").append("<span style='padding:0px 8px;cursor:pointer;' onclick='goToPage("+1+")'>"+1+"</span>");
		for(i=x;i<y;++i){
			if(pageNum==i) $(".numbers").append("<span style='color:#10abfb;padding:0px 8px;cursor:pointer;' onclick='goToPage("+i+")'>"+i+"</span>");
			else if(totalPages>=i&&i>0) $(".numbers").append("<span style='padding:0px 8px;cursor:pointer;' onclick='goToPage("+i+")'>"+i+"</span>");
		}
		if(pageNum<totalPages-2&&totalPages>6) $(".numbers").append("<span>...</span><span style='padding:0px 8px;cursor:pointer;' onclick='goToPage("+totalPages+")'>"+totalPages+"</span>");
		else if(totalPages==6&&i<=6) $(".numbers").append("<span style='padding:0px 8px;cursor:pointer;' onclick='goToPage("+totalPages+")'>"+totalPages+"</span>");
	}
	writeNumbers();
	$("#sortOptions option[value='"+type+"']").attr("selected","selected");
	$("#displayOptions option[value='"+pageDisplay+"']").attr("selected","selected");
	$("#genreOptions option[value='"+genre+"']").attr("selected","selected");
	$(".next").click(function(){
		if(totalPages==pageNum) return;
		++pageNum;
		var url="/fabflix/genre?sort="+type+"&display="+pageDisplay+"&pagenum="+pageNum+"&genre="+genre;
		location.replace(url);
	});
	$("#sortOptions").change(function(){
		var val = $("#sortOptions option:selected").attr("value");
		var url="/fabflix/genre?sort="+val+"&display="+pageDisplay+"&pagenum="+pageNum+"&genre="+genre;
		location.replace(url);
	});
	$(".prev").click(function(){
		if(pageNum==1) return;
		--pageNum;
		var url="/fabflix/genre?sort="+type+"&display="+pageDisplay+"&pagenum="+pageNum+"&genre="+genre;
		location.replace(url);
	});
	function goToPage(num){
		pageNum=num;
		var url="/fabflix/genre?sort="+type+"&display="+pageDisplay+"&pagenum="+pageNum+"&genre="+genre;
		location.replace(url);
	}
	$("#displayOptions").change(function(){
		var val = $("#displayOptions option:selected").attr("value");
	    pageDisplay=parseInt(val);
	    pageNum=1;
		var url="/fabflix/genre?sort="+type+"&display="+pageDisplay+"&pagenum="+pageNum+"&genre="+genre;
		location.replace(url);
	});
	$("#genreOptions").change(function(){
		genre=$("#genreOptions :selected").val();
		pageNum=1;
		var url="/fabflix/genre?sort="+type+"&display="+pageDisplay+"&pagenum="+pageNum+"&genre="+genre;
		location.replace(url);
	});
	$(".movieTitles").hover(function(){
		$(".popup-card").remove();
		clone=$(this).parent().parent().clone();
		var height=$(this).parent().parent().css("height");
		clone.css("margin-top","-"+height);
		clone.find(".cartPoster").css("width","300px").css("margin-left","15%");
		clone.find(".poster").css("height","300px").css("width","300px");
		clone.find(".movieID").parent().css("margin-left","60%");
		clone.removeClass("movie-card").addClass("popup-card");
		clone.find(".trailerURL").removeClass("hidden");
		$(this).parent().parent().append(clone);
		$(".popup-card").hover(function(){},function(){
			$(".popup-card").remove();
		});
	},function(){ 
		
		//console.log("Hover"); 
	});
</script>
</html>