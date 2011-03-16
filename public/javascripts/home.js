$(function() {
	$('#search').submit(function(e) {
		e.preventDefault();
		
		var data = { o: $(this).find('input.offset').val() };
		var searchBox = $(this).find('input.search-box');
		if(searchBox.val() != searchBox.data('placeholderVal'))
			data['q'] = searchBox.val();
		
        $.ajax({ url: $(this).attr('action'), type: $(this).attr('method'), data: data, dataType: 'script' });
	});
	
	$('#search input.search-box')
		.keydown(function(e) {
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
		})
		.data('placeholderVal', $('#search input.search-box').val())
		.focus(function(e) {
			if($(this).val() == $(this).data('placeholderVal')) {
				$(this).removeClass('placeholder');
				$(this).val('');
			}
		})
		.blur(function(e) {
			if($(this).val() == '') {
				$(this).addClass('placeholder');
				$(this).val($(this).data('placeholderVal'));
			}
		});
	
	$('#search input.reset').click(function(e) {
		$('#search input.search-box').val('');
		$('#search input.offset').val('');
		$('#search').submit();
	});
    
    $('#search-results > li.no-bounce').live({
    	mouseover: function(e) {
    		$('#bounce-pop-out')
    			.css({ 
    				display: 'block',
    				top: $(this).position().top, 
    				left: $(this).width() + 20 // Total hack, will figure out later
    			});
    		$('#bounce-toggle-link')
    			.attr('href', '/bounce?id=' + $(this).closest('li').attr('id').replace('follow_', ''));
    	},
    	mouseout: function(e) {
    		// $('#bounce-pop-out')
    		// 	.css({ display: 'none' });
    	}
    });
    
    $('#bounce-calendar').datepicker({ minDate: (new Date(new Date().getTime() + 1000 * 60 * 60 * 24)) });
    
    $('#bounce-toggle-link').click(function(e) {
    	e.preventDefault();
    	
    	var url = $(this).attr('href') + '&t=' + String($('#bounce-calendar').datepicker('getDate').getTime() / 1000);
        $.ajax({ url: url, type: 'get', dataType: 'script' });
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
