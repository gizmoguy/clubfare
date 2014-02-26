var ready;
ready = function() {
  setTimeout(function() {
    var source = new EventSource('/streaming');
    source.addEventListener('refresh', function(e) {
      window.location.reload();
    });
  }, 1);
};

$(document).ready(ready);
$(document).on('page:load', ready);
