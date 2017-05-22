$('.reserve-button').click(function() {
	var substantiv = $(this).parent().data('noun');
	$.ajax({
		type: "POST",
		url: "/substantiv,
		data: substantiv,
		success: success,
		dataType: text
	});
}
