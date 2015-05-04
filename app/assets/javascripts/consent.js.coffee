# Store consent for cookie warnings
jQuery ($) ->
  bodyMarginBottom = parseInt $('body').css('margin-bottom')

  # Show contsent info if the user+UA hasn't made a consent before
  if typeof $.cookie('consent') is 'undefined' or $.cookie('consent') is false
    $('#m-consent').show()

    # Leave room for the box by increasing margin bottom
    consentHeight = parseInt $("#m-consent").outerHeight()
    $('body').css('margin-bottom', bodyMarginBottom + consentHeight)

  $('#m-consent button').click (event) ->
    # Store consent in a persisten cookie and hide the information
    $.cookie 'consent', true, { expires: 365*5, path: '/', domain: 'malmo.se' }

    # Hide box and restore margin bottom
    $('#m-consent').hide()
    $('body').css('margin-bottom', bodyMarginBottom)
