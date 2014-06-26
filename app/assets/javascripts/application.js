// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require_self

$(document).ready(function() {
    $('#sign-in-btn').click(function() {
        // TODO: check availability with server, only if available, connect with google
        $('#signup-choose-domain').hide();
        $('#signup-credit-info').show();
    });

    $('#next-step-signup-btn').click(function() {
        $('#signup-credit-info').hide();
        $('#start-your-free-month').show(); 
    });
    $('#check-avail-btn').click(function() {
        if (!$('#subdomain-input').val()) {
            //don't do anything if text is empty
            $(this).css({'background-color':'#6abc44', 'border-color':'#6abc44', 'color':'white'});
            return;
        } else {
            window.location.href = '/signup/'
        }
    });
    $('#signup-nav-btn').click(function() {
        window.location.href ='/signup/';
    })
});

window.onbeforeunload = function(event)
{
    return confirm("Are you sure you want to refresh? You will lose all signup progress");
};