<html>
<head>
	<title>Fablix</title>
	<link rel="stylesheet" type="text/css" href="main.css">
	<link rel="stylesheet" type="text/css" href="bootstrap.min.css">
	<script src="jquery-3.1.1.min.js"></script>
    <meta charset="UTF-8">
</head>
<body style="background-image:url('bg1.jpg');">
	<div id="mainHeading" class="row" style="">
		<div class="col-md-3" style="margin:21px 0px;left:0;">Fablix</div>
		<form class="col-md-6"><input class="inputbox" type="text" name="search" placeholder="Search" style="border-radius:10px;"></form>
		<div class="col-md-3" Style="margin:35px 0px;right:0;position:absolute;font-size:18px;">Sudharshan Arutselvan</div>
	</div>
	<div class="row movies-list" style="margin:20px;">

	</div>
	<div class="hidden movie-card-template">
		<div class="col-md-3 col-xs-4" style="height:250px;padding:15px;">
			<div id="poster">
				<img src="memento.jpg" style="height:100%;width:100%;">
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
	var i;
	var movieNames=${movies};
	var moviePosters=${images};
	for(i=0;i<10;i++){
		movie=$(".movie-card-template").clone();
		movie.removeClass("movie-card-template").removeClass("hidden");
		$(".movies-list").append(movie);
	}
</script>
</html>