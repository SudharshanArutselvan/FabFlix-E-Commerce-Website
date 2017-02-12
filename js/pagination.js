var pageDisplay=10;
var pageNum=1;
var i;

$(".movie-card").slice(0,pageDisplay).removeClass("hidden");
var totalMovies=$(".movie-card").length;
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
var type=$("#sortOptions").attr("val");
$("#sortOptions option[value='"+type+"']").attr("selected","selected");
$(".next").click(function(){
	if(totalPages==pageNum) return;
	var offset=pageNum*10;
	var offset1=(pageNum-1)*10;
	$(".movie-card").slice(offset,offset+pageDisplay).removeClass("hidden");
	$(".movie-card").slice(offset1,offset1+pageDisplay).addClass("hidden");
	++pageNum;
	writeNumbers();
});
$(".prev").click(function(){
	if(pageNum==1) return;
	var offset=(pageNum-1)*10;
	var offset1=(pageNum-2)*10;
	$(".movie-card").slice(offset1,offset1+pageDisplay).removeClass("hidden");
	$(".movie-card").slice(offset,offset+pageDisplay).addClass("hidden");
	--pageNum;
	writeNumbers();
});
function goToPage(num){
	pageNum=num;
	var offset=pageNum*10;
	var offset1=(pageNum-1)*10;
	$(".movie-card").addClass("hidden");
	$(".movie-card").slice(offset1,offset1+pageDisplay).removeClass("hidden");		
	writeNumbers();
}
$("#displayOptions").change(function(){
	var val = $("#displayOptions option:selected").attr("value");
    pageDisplay=parseInt(val);
    pageNum=1;
    totalPages=Math.ceil(totalMovies/pageDisplay);
    var offset=pageNum*10;
	var offset1=(pageNum-1)*10;
	$(".movie-card").addClass("hidden");
	$(".movie-card").slice(offset1,offset1+pageDisplay).removeClass("hidden");
	writeNumbers();
});