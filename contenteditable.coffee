jQuery ($) ->

  $(document.body)

    # Capture clicks on the containing element.
    .delegate '.contenteditable', 'click', (event) ->
      # If the user clicked on the text directly, do nothing.
      return unless $(event.target).hasClass 'contenteditable'

      el = event.target.firstChild
      el.focus()

      # Create a `Range` spanning the text node.
      range = document.createRange()
      range.selectNode el.firstChild

      # Make the `Range` visible.
      selection = window.getSelection()
      selection.removeAllRanges()
      selection.addRange range

    # Capture and suppress enter/return keystrokes, and trigger custom event.
    .delegate '[contenteditable]', 'keydown', (event) ->
      if event.keyCode is 13
        event.preventDefault()
        $(this).trigger 'contentedited'
