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
//= require rails-ujs
//= require activestorage
//= require jquery3
//= require turbolinks
//= require_tree .


$(function(){
    $("#search").keyup(function(){
        var texto = $(this).val();
        $("#table tr").css("display", "table-row");
        $("#table tr").each(function(){
            if($(this).text().toUpperCase().indexOf(texto.toUpperCase()) < 0)
				   $(this).css("display", "none");
        });
    });
});

function format(mask, doc){
  var i = doc.value.length;
  var out = mask.substring(0,1);
  var text = mask.substring(i)
  
  if (text.substring(0,1) != out){
            doc.value += text.substring(0,1);
  }
}