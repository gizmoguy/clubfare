var ready;
ready = function() {
	setTimeout(function() {
		var source = new EventSource('/streaming');
		source.addEventListener('refresh', function(e) {
			$.get('/dash.js');
    	});
		source.onerror = function() {
			console.log('Error!');
			console.log(arguments);
		};
		setInterval(function() {
			$('#event_source_status').html(source.readyState);
		}, 1000);
  	}, 1);
};

$(document).ready(ready);
$(document).on('page:load', ready);
