// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

var ready = function() {
    if($('.beer-list').length){
        var etag = null;
        setInterval(function () {
            $.ajax('/api/beers', {
                success: function (data, textStatus, xhr) {
                    if (etag == null) {
                        etag = xhr.getResponseHeader('Etag');
                    }

                    if (xhr.getResponseHeader('ETag') != etag) {
                        // Page needs refreshing because etag has changed
                        location.reload();
                    }
                }
            });
        }, 10000);
    }
};

$(document).ready(ready);
$(document).on('page:load', ready);
