$(function() {
	
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
