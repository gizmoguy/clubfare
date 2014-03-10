var source;
var ready = function() {
	
	source = new EventSource('/streaming');
	source.addEventListener('refresh', updateDash); 

	setInterval(function() {
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
				$('#event_source_status').html(source.readyState);
				source = new EventSource('/streaming');
				source.addEventListener('refresh', updateDash);
				break;
				
			default:
				// this can't happen
				break; // why break when there's nothing below it?
		}
	}, 1000);
};

updateDash = function(e) {
	$.get('/dash.js');
}

$(document).ready(ready);
$(document).on('page:load', ready);
