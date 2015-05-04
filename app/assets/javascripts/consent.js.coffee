# Store consent for cookie warnings
jQuery ($) ->
  # Show contsent info if the user+UA hasn't made a consent before
  if typeof $.cookie('consent') is 'undefined' or $.cookie('consent') is false
    $('#m-consent').show()

    # Leave room for the box by increasing margin bottom
    $('body').css('margin-bottom',
      parseInt($('body').css('margin-bottom')) + parseInt($("#m-consent").outerHeight()))

  $('#m-consent button').click (event) ->
    # Store consent in a persisten cookie and hide the information
    $.cookie 'consent', true, { expires: 365*5, path: '/', domain: 'malmo.se' }
    ga('send', 'event', "CookieConsent", 'yes', 1)

    # Hide box and restore margin bottom
    $('#m-consent').hide()
    $('body').css('margin-bottom', 0)
