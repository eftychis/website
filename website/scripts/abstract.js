(function($){
    $("a.showabstract").on("click", null, function(e){
	e.preventDefault();
	console.log(this)
	$(this).parent().find("div.pub-abstract").toggleClass("hide");
    });
})(jQuery);
