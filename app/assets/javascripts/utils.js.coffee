jQuery ($) ->
  # Add class `touch` tp body for enabled devices
  if "ontouchstart" of window
    $("body").addClass "touch"

  # Adjust scroll position for fixed masthead on page load and hashchange
  # To prevent this behaviour, set preventScrollForMasthead = true
  $(window).on 'hashchange ready', ->
    if $("#malmo-masthead").css('position') is 'fixed' and
        (typeof preventScrollForMasthead is 'undefined' or preventScrollForMasthead is false)
      setTimeout ->
        window.scrollBy(0, -60)
      , 10
