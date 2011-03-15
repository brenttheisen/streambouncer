$(function() {
	
	$('#search input.search-box').keydown(function(e) {
		var lastTimerID = $(this).data('autoCompleteTimerID');
		if(lastTimerID != undefined)
			clearTimeout(lastTimerID);
		
		var timerID = setTimeout(function(){
			var searchBox = $('#search input.search-box');
			var lastVal = searchBox.data('lastVal');
			if(lastVal == undefined || lastVal != searchBox.val())
				$('#search').submit();
			searchBox.data('lastVal', searchBox.val());
		}, 200);
		$(this).data('autoCompleteTimerID', timerID);
	});
	
	$('#search input.reset').click(function(e) {
		$('#search input.search-box').val('');
		$('#search').submit();
	});
	
	$('a.oauth').click(function (e) {
		e.preventDefault();
		
		window.open($(this).attr('href'), "oauthWindow", "width=800,height=450,scrollbars=no,dependent=no");
	});
	
    $('form.ajax').submit(function(e) {
        e.preventDefault();
        
        $.ajax({ url: $(this).attr('action'), type: $(this).attr('method'), data: $(this).serialize(), dataType: 'script' });
    });
    
    $('a.ajax').click(function(e) {
        e. preventDefault();
        
        $.ajax({ url: $(this).attr('href'), dataType: 'script'});
    });
});
