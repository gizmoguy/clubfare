var source;
var ready = function() {
	
	source = new EventSource('/streaming');
	source.addEventListener('refresh', updateDash); 

	setInterval(function() {
		switch (source.readyState) {
			case EventSource.CONNECTING:
				// do nothing yet
				$('#event_source_status').html("");
				break;
				
			case EventSource.OPEN:
				// this is normal
				$('#event_source_status').html("");
				break;
				
			case EventSource.CLOSED:
				// Start a new listener
				$('#event_source_status').html("<b>Connection Lost. Please refresh me.</b>");
				source = new EventSource('/streaming');
				source.addEventListener('refresh', updateDash);
				break;
				
			default:
				// this can't happen
				$('#event_source_status').html(source.readyState);
				break;
		}
	}, 1000);
};

updateDash = function(e) {
	$.get('/dash.js');
}

$(document).ready(ready);
$(document).on('page:load', ready);
