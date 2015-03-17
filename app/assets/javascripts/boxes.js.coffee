jQuery ($) ->
  # Show instructions for the section
  $toggleInstructions = $('.box-2 .toggle-instructions, .box .toggle-instructions')

  if $toggleInstructions.length
    $toggleInstructions.click ->
      $(@).closest('.box, .box-2').find('.box-instructions').toggle()
      $(@).closest('.dropdown').removeClass("open")
      return false
