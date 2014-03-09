var ready;
ready = function() {
	setTimeout(function() {
		var source = new EventSource('/streaming');
		source.addEventListener('refresh', function(e) {
			$.get('/dash.js');
    	});
		switch (source.readyState) {
			case EventSource.CONNECTING:
				// do nothing yet
				$('#event_source_status').html(source.readyState);
				break;
			case EventSource.OPEN:
				// this is normal
				$('#event_source_status').html(source.readyState);
				break;
			case EventSource.CLOSED:
				// Start a new listener
				var source = new EventSource('/streaming');
				source.addEventListener('refresh', function(e) {
					$.get('/dash.js');
				});
				$('#event_source_status').html(source.readyState);
				break;
			default:
				// this can't happen
				break;
		}
  	}, 1000);
};

$(document).ready(ready);
$(document).on('page:load', ready);
