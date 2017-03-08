$(".poster").click(function(){
	var link=$(this).parent().parent().attr("href");
	var url = window.location.href;
	var loc=window.location.pathname;
	var get=window.location.search;
	url=url.substring(0,url.length-loc.length-get.length)+link;
	window.open(url,"_self");
});
$("#browsegenre").click(function(){
	var url = window.location.href;
	var loc=window.location.pathname;
	var get=window.location.search;
	url=url.substring(0,url.length-loc.length-get.length)+"/fabflix/genre";
	window.open(url,"_self");
});
$("#browseMovie").click(function(){
	var url = window.location.href;
	var loc=window.location.pathname;
	var get=window.location.search;
	url=url.substring(0,url.length-loc.length-get.length)+"/fabflix/home";
	window.open(url,"_self");
});
$("#searchMovie").click(function(){
	var url = window.location.href;
	var loc=window.location.pathname;
	var get=window.location.search;
	url=url.substring(0,url.length-loc.length-get.length)+"/fabflix/search";
	window.open(url,"_self");
});
$("#logoHeading").click(function(){
	var url = window.location.href;
	var loc=window.location.pathname;
	var get=window.location.search;
	url=url.substring(0,url.length-loc.length-get.length)+"/fabflix/home";
	window.open(url,"_self");
});
$(".addToCart").click(function(){
	movID=$(this).parent().parent().attr("movid");
	var cookieString = document.cookie.split(";");
	var movIDarr;
	if(cookieString.length>1){
		var i;
		for(i=0;i<cookieString.length;++i){
			var x=cookieString[i].split("=");
			if(x[0]=="movie"||x[0]==" movie"){
				if(x[1]!="") movIDarr=JSON.parse(x[1]);
			}
			console.log("x:"+x[1]);
			
		}
		if(movIDarr){
			var len=movIDarr.length;
			movIDarr[len]=movID;
		}
		else{
			movIDarr=movID;
		}
		console.log(movIDarr[len]);
	} 
	else {
		movIDarr=movID;
	}
	if(cookieString.length>2) document.cookie="movie="+movIDarr;
	else document.cookie="movie=["+movIDarr+"]";
	console.log(document.cookie);
	alert("Movie has been added to cart");
});
$("#nameDropDown").hide();
$("#cart").click(function(){
	var url = window.location.href;
	var loc=window.location.pathname;
	var get=window.location.search;
	url=url.substring(0,url.length-loc.length-get.length)+"/fabflix/cart";
	window.open(url,"_self");
});
$("#logoff").click(function(){
	var x=document.cookie.split(";");
	for(var i=0;i<x.length;i++){
		document.cookie=x[i].split("=")[0]+"=";
	}
	console.log(document.cookie);
	var url = window.location.href;
	var loc=window.location.pathname;
	var get=window.location.search;
	url=url.substring(0,url.length-loc.length-get.length)+"/fabflix/logout";
	window.open(url,"_self");
});
$("#drop").click(function(){
	$("#nameDropDown").toggle();
});
$("#topsearch").on('keyup',function(event){
		var str=$("#topsearch").val();
		var keyCode = (event.keyCode ? event.keyCode : event.which);
		if(keyCode==8&&str==""){
			$("#searchDrop").find("div").remove();
			return;
		}
		$.ajax({
			url: "/fabflix/searchBar",
			method: "GET",
		    data:{"searchStr":str}
		}).done(function(msg) {
			$("#searchDrop").find("div").remove();
			$("#searchDrop").html(msg);
		});
	});