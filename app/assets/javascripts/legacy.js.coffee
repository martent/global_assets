jQuery ($) ->
  # For missing placeholder support (IE9)
  unless 'placeholder' of document.createElement('input')
    setPlaceholder = (self) ->
      if $(self).val() is '' or $(self).val() is $(self).attr('placeholder')
        $(self).addClass('placeholder')
        $(self).val($(self).attr('placeholder'))

    # Bind events
    $('.mf-v4').on "focus", "input[placeholder]", ->
      if $(@).val() is $(@).attr('placeholder')
        $(@).val('')
        $(@).removeClass('placeholder')
    $('.mf-v4').on "blur", "input[placeholder]", ->
      setPlaceholder(this)

    # Set on load
    $('.mf-v4 input[placeholder]').each ->
      setPlaceholder(@)

    # Clear before submit
    $('.mf-v4 input[placeholder]').parents('form').submit ->
      $(@).find('input[placeholder]').each ->
        if $(@).val() is $(@).attr('placeholder')
          $(@).val('')
