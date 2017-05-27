<html>
<%@ page import="java.io.*,java.net.*,java.sql.*,javax.sql.*,java.text.*,java.util.*,javax.servlet.*,javax.servlet.http.*,javax.naming.InitialContext,javax.naming.Context,javax.sql.DataSource"%>
<%@ page language="java" import="java.sql.*" errorPage=""%>
<head>
	<title>FabFlix</title>
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
		<form class="col-md-6" action="/fabflix/result" method="GET"><input class="inputbox" type="text" id="topsearch" name="search" placeholder="Search" style="border-radius:10px;">
			<div id="searchDrop" style="position:absolute;top:72px;right:0px;border-radius:5px;width:100%;cursor:pointer;padding:1px 15px;">
				
			</div>
		</form>
		<div id="customerName" class="col-md-3" Style="margin:35px 0px;font-size:18px;" uname="<%out.print(session.getAttribute("name"));%>"><span id="drop" style="cursor:pointer;"><%out.print(session.getAttribute("name"));%><i class="material-icons" style="color:#4aa7f6;font-size:15px;">arrow_drop_down</i></span>
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

				String headerCookie=request.getHeader("Cookie");
				String[] items={""};
				int i=0,flag=0;
				for (String retval: headerCookie.split(";")) {
					if(retval.length()>=6){
						if(retval.substring(1,6).compareTo("movie")==0){
							i=10;
				        	if(retval.substring(7).compareTo("")==0){ flag=1; break; }
				        	else if(retval.substring(7).compareTo("[]")==0){ flag=1; break; }
				        	else items=(retval.substring(7)).replaceAll("\\[", "").replaceAll("\\]", "").replaceAll("\\s", "").split(",");
				        }
					}
			    }
			    if(i==0) flag=1;
			    if(flag==1) out.println("<div id='noMovie'>Your shopping cart is empty!</div>");
			    else{
			    	int[] movIDarr = new int[items.length];
					for (i = 0; i < items.length; i++) {
						try{
							movIDarr[i] = Integer.parseInt(items[i]);
					    } catch (NumberFormatException nfe) {
					    	out.println(nfe.getMessage());
					    }
					}
					int[] numMov=new int[movIDarr.length];
					for(i=0;i<movIDarr.length;i++){
						int k;
						for(k=0;k<i;k++){
							if(movIDarr[k]==movIDarr[i]){
								if(numMov[k]>=1) numMov[k]++;
								else numMov[k]=1;
								break;
							}
						}
						if(k==i) numMov[i]=1; 
					}
					double sum=0;
					for(int j=0;j<movIDarr.length;j++){
						if(numMov[j]>0){
							PreparedStatement movieQuery = dbcon.prepareStatement("SELECT * from movies where id=?");
							//String moviequery = "SELECT * from movies where id="+movIDarr[j];
							//ResultSet movieresult = statement.executeQuery(moviequery);
							movieQuery.setInt(1,movIDarr[j]);
							ResultSet movieresult = movieQuery.executeQuery();
							while(movieresult.next())
							{  
								int movieID = movieresult.getInt("id");
								String moviename = movieresult.getString("title");
								String banner_url = movieresult.getString("banner_url");
								int year = movieresult.getInt("year");
								String director = movieresult.getString("director");
								double total=19.99*numMov[j];
								out.println("<div class='row movie-card' style='padding:15px;width:100%' movid="+movieID+" href='/fabflix/movie?id="+movieID+"'><div class='movieID' style='padding:10px;text-align:left;display:inline'>Movie ID : "+movieID+"</div><div class='movieTitles' style='padding:10px;text-align:left;display:inline'> Movie : "+moviename+"</div><div class='quantity' style='padding:10px;text-align:left;display:inline'>Quantity : "+numMov[j]+"</div><div class='price' style='padding:10px;text-align:left;display:inline'>Price : $19.99</div><br><label for='qt' style='color:#ccc;'>Enter quantity to change</label><input id='changeQuantity' type='text' name='qt' old="+numMov[j]+" style='width:50px;padding:5px 10px;margin:15px;font-size:14px;'><button type='button' class='updateQuantity btn btn-default' style='margin: 0px 20px;width:100px;''>Update</button><br><div class='total' style='padding:10px;text-align:left;display:inline'>Total Price : $"+total+"</div></div>");
								sum+=total;
							}
							movieQuery.close();
							movieresult.close();
						}
					}
					out.println("<div id='finalCost' sum="+sum+" style='padding:10px;display:inline;'>Final Cost : $"+sum+"</div>");
					dbcon.close();
			    }
			%>
		</div>
		<button type='button' id='checkout' class='btn btn-default' style='margin: 0px 20px;width:140px;display:none;' data-toggle='modal' data-target='#checkoutModal'>Checkout</button>
	</center>
	<!-- Modal -->
	<div id="checkoutModal" class="modal fade" role="dialog">
	  <div class="modal-dialog">

	    <!-- Modal content-->
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal">&times;</button>
	        <h4 class="modal-title">Credit Card Details</h4>
	      </div>
	      <div class="modal-body">
	        <form id="checkoutform">
	        	<label>First Name</label>
			  	<input id="fname" type="text" name="creaditcard" placeholder="First name" style="border-radius:5px;width: 100%;font-size: 15px;padding: 5px 10px;" autofocus required>
			  	<label>Last Name</label>
			  	<input id="lname" type="text" name="date" placeholder="Last name" style="border-radius:5px;width: 100%;font-size: 15px;padding: 5px 10px;" required>
			  	<label>Credit Card number</label>
			  	<input id="credit" type="text" name="creaditcard" placeholder="creditcard" style="border-radius:5px;width: 100%;font-size: 15px;padding: 5px 10px;" required>
			  	<label>Expiry date</label>
			  	<input id="date" type="text" name="date" placeholder="YYYY-MM-DD" style="border-radius:5px;width: 100%;font-size: 15px;padding: 5px 10px;" required>
			</form>
	      </div>
	      <div class="modal-footer">
	        <button type="button" id="checkoutconfirm" class="btn btn-default">Submit</button>
	      </div>
	    </div>

	  </div>
	</div>
</body>
<script src="./js/links.js" type="text/javascript"></script>
<script type="text/javascript">
	if($(".movie-card").length>0) $("#checkout").show();
	$(".updateQuantity").click(function(){
		var old=$(this).parent().find("#changeQuantity").attr("old");
		var updated=$(this).parent().find("#changeQuantity").val();
		var id=$(this).parent().attr("movid");
		console.log(id);
		var movIDarr;
		var cookieString = document.cookie.split(";");
		var i;
		for(i=0;i<cookieString.length;++i){
			if(i==0 && cookieString[i].substring(0,5)=="movie") movIDarr=JSON.parse(cookieString[i].substring(6));
			else if(cookieString[i].substring(1,6)=="movie") movIDarr=JSON.parse(cookieString[i].substring(7));
		}
		if(updated == 0){
			for(i=0;i<movIDarr.length;i++){
				if(movIDarr[i]==id) movIDarr.splice(i,1);
				i--;
			}
			$(this).parent().remove();
		}
		else if(updated>0) {
			if(updated>old){
				var len=movIDarr.length;
				for(i=0;i<updated-old;i++){
					movIDarr[len+i]=id;
				}
			}
			if(updated<old){
				var c=old-updated;
				for(i=0;i<movIDarr.length;i++){
					if(movIDarr[i]==id&&c>0){
						movIDarr.splice(i,1);
						i--;
						c--;	
					} 
				}
			}
			$(this).parent().find("#changeQuantity").attr("old",updated);
			$(this).parent().find(".quantity").text("Quantity : "+updated);
			$(this).parent().find(".total").text("Total Price : $"+(19.99*updated));
		}
		else{
			alert("Wrong Input");
			return;
		}
		var sum=parseFloat($("#finalCost").attr("sum"));
		sum=sum+(updated-old)*19.99;
		$("#finalCost").attr("sum",sum);
		$("#finalCost").text("Final Cost : $"+sum);
		if(sum ==0){
			$("#finalCost").text("Your shopping cart is empty!");
			$("#checkout").hide();
		}
		if(cookieString.length>2) document.cookie="movie="+movIDarr;
		else document.cookie="movie=["+movIDarr+"]";
		$(this).parent().find("#changeQuantity").val("");
		alert("Quantity has been changed");
	});
	$("#checkoutconfirm").click(function(){
		var fn = $("#fname").val(), ln=$("#lname").val();
		var name=fn+" "+ln;
		if(name==$("#customerName").attr("uname")){
			var creditcard=$("#credit").val();
			var date=$("#date").val();
			console.log(name+" "+creditcard+" "+date);
			$.ajax({
			  url: "http://ec2-52-40-45-138.us-west-2.compute.amazonaws.com:8080/fabflix/checkout",
			  method: "GET",
			  data:{"fname":fn,"lname":ln,"id":creditcard,"date":date}
			}).done(function(msg) {
				console.log(msg);
				if(msg=="Success"){
					document.cookie="movie=";
					$(".movie-card").remove();
			  		$("#finalCost").text("Your shopping cart is empty!");
					$("#checkout").hide();
				}
			  	alert(msg);
				$('#checkoutModal').modal('hide');
			});
		}
		else {
			alert("Username is wrong");
		}
	});
</script>
</html>