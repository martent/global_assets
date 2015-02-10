# Intranet specific GA logging
jQuery ($) ->
  # Track department/working field from cookie as Event logging
  $.cookie.json = true
  profile = $.cookie('myprofile') or {}
  _gaq.push(['_trackEvent', 'Department', profile.department or 'none'])
  _gaq.push(['_trackEvent', 'WorkingField', profile.workingfield or 'none'])

  # Tracking of categories and author for "Nyheter" and "Blogg". `newsTracking` and `blogTracking` is defined on those sites
  if typeof newsTracking isnt 'undefined'
    $.each newsTracking['categories'], (index, category) ->
      _gaq.push(['_trackEvent', 'newsCategory',   "newsCategory-" + category])
    _gaq.push(['_trackEvent', 'newsAuthor', "newsAuthor-" + newsTracking['author']])

  if typeof blogTracking isnt 'undefined'
    $.each blogTracking['categories'], (index, category) ->
      _gaq.push(['_trackEvent', 'blogCategory', "blogCategory-" + category])
    _gaq.push(['_trackEvent', 'blogAuthor', "blogAuthor-" + blogTracking['author']])

  # GA event tracking of top menu selection
  $("#malmo-masthead .nav-logo a, #malmo-masthead nav li[class!='dropdown'] a, #malmo-masthead nav li.dropdown ul a").click (event) ->
    $a = $(@);

    # Special case for department & workingfield dropdowns
    if $a.parents("#nav-my-department").length then text = "Min förvaltning"
    else if $a.parents("#nav-my-workingfield").length then text = "Mitt arbetsfält"
    else if $a.parents("#masthead-others").length then text = $a.attr("title")
    else text = $a.text()

    _gaq.push(['_trackEvent', 'topMenuClick', text, $a.attr('href').replace(/https*:\/\/.*\//, '/')])
    gaDelayEvent($a, event)
