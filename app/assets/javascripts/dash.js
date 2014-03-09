var ready;
ready = function() {
	setTimeout(function() {
		var source = new EventSource('/streaming');
		source.addEventListener('refresh', function(e) {
			$.get('/dash.js');
    	});
		source.onerror = function() {
			source.close();
			source.addEventListener('refresh', function(e) {
				 $.get('/dash.js');
			});
		};
  	}, 1);
};

$(document).ready(ready);
$(document).on('page:load', ready);
