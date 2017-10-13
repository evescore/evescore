// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require bootstrap-select
//= require typeahead.js/dist/bloodhound.js
//= require typeahead.js/dist/typeahead.bundle.js
//= require handlebars/dist/handlebars.min.js
//= require_tree .

$(document).on('turbolinks:load', function() {
  $('[data-toggle="tooltip"]').tooltip({ html: true });
  $('[data-toggle="tooltip"]').click(function() {
    $(this).tooltip('hide');
  })
  
  $('.selectpicker').selectpicker();
  var typeaheadSource = new Bloodhound({
    datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name'),
    queryTokenizer: Bloodhound.tokenizers.whitespace,
    remote: {
      url: '/search?query=%QUERY',
      wildcard: '%QUERY'
    }
  });

  $('#search').typeahead(null, {
    display: 'name',
    source: typeaheadSource,
    templates: {
      suggestion: Handlebars.compile('<div><img class=img-rounded src={{image}}>&nbsp;{{name}}</div>')
    }
  });
  
  $('#search').bind('typeahead:select', function(ev, suggestion) {
    window.location.pathname = suggestion.path
  });
})
