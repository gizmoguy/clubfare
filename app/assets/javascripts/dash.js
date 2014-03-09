var ready;
ready = function() {
	var source = new EventSource('/streaming');
	source.addEventListener('refresh', function(e) {
		$.get('/dash.js');
   	});
};

$(document).ready(ready);
$(document).on('page:load', ready);
