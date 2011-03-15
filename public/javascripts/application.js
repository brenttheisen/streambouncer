$(function() {
	
	$('#search input.search-box').keydown(function(e) {
		var lastTimerID = $(this).data('autoCompleteTimerID');
		if(lastTimerID != undefined)
			clearTimeout(lastTimerID);
		
		var timerID = setTimeout(function(){
			var searchBox = $('#search input.search-box');
			var lastVal = searchBox.data('lastVal');
			if(lastVal == undefined || lastVal != searchBox.val()) {
				$('#search input.offset').val('');
				$('#search').submit();
			}
			searchBox.data('lastVal', searchBox.val());
		}, 200);
		$(this).data('autoCompleteTimerID', timerID);
	});
	
	$('#search input.reset').click(function(e) {
		$('#search input.search-box').val('');
		$('#search input.offset').val('');
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
    
    $(window).scroll(function(e) {
    	var offset = $('#search input.offset').val();
    	if(offset != '-1') {
	    	var resultsTotalLength = $('#search-results').offset().top + $('#search-results').height();
	    	var windowTotalLength = $(window).scrollTop() + $(window).height();
	    	if(resultsTotalLength - windowTotalLength < 300 && $('#search-results > li.loading-more-results').length == 0) {
		    	$('#search-results').append('<li class="loading-more-results">Loading more results...</li>');
		    	
		    	offset = isNaN(offset) ? 0 : $('#search-results > li').length - 1;
		    	if(offset != -1) {
			    	$('#search input.offset').val(String(offset));
			    	$('#search').submit();
		    	}
	    	}
    	}
    });
});
