$(function() {
	
	$('#search input[name="q"]').keypress(function(e) {
		var lastTimerID = $(this).data('autoCompleteTimerID');
		if(lastTimerID != undefined)
			clearTimeout(lastTimerID);
		
		var timerID = setTimeout(function(){
			$('#search').submit();
		}, 200);
		$(this).data('autoCompleteTimerID', timerID);
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
