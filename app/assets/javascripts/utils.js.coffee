jQuery ($) ->
  # Add class `touch` tp body for enabled devices
  if "ontouchstart" of window
    $("body").addClass "touch"

  # Adjust scroll position for fixed masthead on page load and hashchange
  # To prevent this behaviour, set preventScrollForMasthead = true
  $(window).on 'hashchange load', ->
    setTimeout ->
      if window.location.hash and $("#malmo-masthead").css('position') is 'fixed' and
          (typeof preventScrollForMasthead is 'undefined' or preventScrollForMasthead is false) and
          ($(window.location.hash).length and $(window.location.hash).offset().top - $(window).scrollTop() < 55)
        window.scrollBy(0, -60)
    , 100
