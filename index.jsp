<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>Fablix</title>
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="icon" type="image/jpg" href="./images/icon.jpg" />
	<link rel="stylesheet" type="text/css" href="./css/login.css">
	<link rel="stylesheet" type="text/css" href="./css/bootstrap.min.css">
	<script src="./js/jquery-3.1.1.min.js"></script>
	<script src="./js/bootstrap.min.js"></script>
    <meta charset="UTF-8">
    <div class="hidden" id="sessionCheck" name=<%out.print(session.getAttribute("name"));%> login=<%out.print(session.getAttribute("check"));%>> </div>
    <script type="text/javascript">
		var sessionName=$("#sessionCheck").attr("name");
		console.log(sessionName);
		if(sessionName!="null"){
			var url = window.location.href;
			url=url+"home";
			location.replace(url);
		}
	</script>
</head>
<body style="background-image:url('./images/bg1.jpg');">
	<div id="loginHeading" class="row">
		<div style="margin:21px 0px;">Fablix</div>
	</div>
	<center><div id='failed' style="display:none;font-size:20px;color:#FFF;">Login Failed!</div></center>
	<div id="logindiv">
		<div id="username" >
			<form action="/Fablix/login" method="POST">
			  <div class="input_names row">Email: </div><input class="inputbox row" type="text" name="email" style="color:#000;" required autofocus><br>
			  <div class="input_names row">Password: </div><input class="inputbox row" type="password" name="password" style="color:#000;" required><br>
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
