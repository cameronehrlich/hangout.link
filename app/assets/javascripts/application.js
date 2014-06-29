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

    // On button press
    $('#check-avail-btn').click(function() {
        performSubdomainCheck();
    });
    
    // On return key
    $('#subdomain-input').on( "keydown", function(event) {
        if(event.which == 13){
            performSubdomainCheck();
        }
    });

    function performSubdomainCheck(){
        if (!$('#subdomain-input').val()) {
            //don't do anything if text is empty
            $(this).css({'background-color':'#6abc44', 'border-color':'#6abc44', 'color':'white'});
            return;
        } else {
            $.ajax({
                url: 'api/check_subdomain',
                type: 'GET',
                dataType: 'json',
                data: {subdomain: $('#subdomain-input').val()},
            })
            .done(function(results) {
                if (results["valid"]) {
                    // Subdomain is valid and available
                    $('#check-avail-btn').text("Get Started!");
                    $('#feedback-div').text("Available!");
                    $('#feedback-div').css({'color':'#00FF00'});
                    $('#check-avail-btn').click(function() {
                        window.location = '/signup?subdomain='+$('#subdomain-input').val();
                    });
                }else{
                    //subdomain was not valid for some reason, try again
                    $('#check-avail-btn').text("Check Availability");
                    $('#feedback-div').text(results["errors"].join(', '));
                    $('#feedback-div').css({'color':'#FF0000'});
                    $('#check-avail-btn').click(function() {
                        performSubdomainCheck();
                    });
                }
            })
            .fail(function() {
                $('#check-avail-btn').text("Check Availability");
                $('#feedback-div').text("Something went wrong, try again later.");
                $('#feedback-div').css({'color':'#FF0000'});
                $('#check-avail-btn').click(function() {
                    performSubdomainCheck();
                });
            });
        }
    }

    $('#signup-nav-btn').click(function() {
        window.location.href ='/signup/';
    });
});