<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>FabFlix</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="icon" type="image/jpg" href="./images/icon.jpg" />
	<link rel="stylesheet" type="text/css" href="./css/login.css">
	<link rel="stylesheet" type="text/css" href="./css/bootstrap.min.css">
	<script src='https://www.google.com/recaptcha/api.js'></script>
	<script src="./js/jquery-3.1.1.min.js"></script>
	<script src="./js/bootstrap.min.js"></script>
    <meta charset="UTF-8">
    <div class="hidden" id="sessionCheck" name=<%out.print(session.getAttribute("emp"));%> login=<%out.print(session.getAttribute("empcheck"));%>> </div>
    <script type="text/javascript">
		var sessionName=$("#sessionCheck").attr("name");
		console.log(sessionName);
		if(sessionName!="null"){
			var url = window.location.pathname;
			url=url.substring(0,9)+"_dashboard";
			location.replace(url);
		}
	</script>
	<style type="text/css">
		.g-recaptcha div{
			margin-left:auto;
			margin-right:auto;
		}
	</style>
</head>
<body style="background-image:url('./images/bg1.jpg');">
	<div id="loginHeading" class="row">
		<div style="margin:21px 0px;">FabFlix</div>
	</div>
	<center><div id='failed' style="display:none;font-size:20px;color:#FFF;">Login Failed!</div></center>
	<div id="logindiv" style="width:340px;margin-left:auto;margin-right:auto;">
		<a id='dashboard' href="/fabflix/" style="font-size:20px;color:#FFF;">Customer Login</a>
		<a id='dashboard' href="/fabflix/employeeLogin" style="font-size:20px;color:#f1a1a1;float:right;">Employee Login</a>
		<div id="username" style="width:100%;">
			<form action="/fabflix/emplogin" method="POST">
			  <div class="input_names row">Email: </div><input class="inputbox row" type="text" name="email" style="color:#000;" required autofocus><br>
			  <div class="input_names row">Password: </div><input class="inputbox row" type="password" name="password" style="color:#000;" required><br>
			  <div class="g-recaptcha row" data-sitekey="6Lf7zRUUAAAAAOfIw_lLD8QNnR6u9YauFqtbjQt_" style="margin-top:20px;"></div>
			  <input class="btn btn-default" type="submit" value="Submit" style="width:100%;margin:36px 0px 15px;padding:10px;background-color:#4aa7f6;border:none;">
			  <!-- <input class="submitbutton row" type="submit" value="Submit"> -->
			</form>
		</div>
	</div>
</body>
<script type="text/javascript">
	if($("#sessionCheck").attr("login")=="failed") $("#failed").show();
	setTimeout(function() {
  		$("#failed").hide();
	}, 3000);
</script>
</html>
