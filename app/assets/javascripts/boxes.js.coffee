jQuery ($) ->
  # Show instructions for the section
  $toggleInstructions = $('.box .toggle-instructions')

  if $toggleInstructions.length
    $toggleInstructions.click ->
      $(@).closest('.box').find('.box-instructions').toggle()
      $(@).closest('.dropdown').removeClass("open")
      return false
