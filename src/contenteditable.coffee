jQuery ($) ->

  # Copied from the CoffeeScript translation of Underscore.
  nativeIndexOf = Array::indexOf
  indexOf = (array, item) ->
    if nativeIndexOf and array.indexOf is nativeIndexOf
      return array.indexOf item
    idx = 0; len = array.length
    while len - idx
      if array[idx] is item then return idx else idx += 1
    -1

  elements = []
  saved_text = []

  # Save an element's text.
  save = (el, text) ->
    idx = indexOf elements, el
    if idx is -1
      idx = elements.length
      elements[idx] = el
    saved_text[idx] = text

  # Return an element's saved text.
  last_saved = (el) ->
    idx = indexOf elements, el
    return if idx is -1
    saved_text[idx]

  # Determine whether `el` is yet to be added to `elements`.
  unsaved = (el) ->
    indexOf(elements, el) is -1

  # Decorate `fn` such that it only handles events originating from
  # "contenteditable" elements. This filters out any false positives
  # returned by jQuery < 1.7 in Opera and Safari 4.
  is_editable = (fn) ->
    (event) -> fn.call this, event if @contentEditable is 'true'

  $input = $(
    '<input style=position:absolute;left:-9999px tabindex=-1>'
  ).appendTo document.body

  $('html')

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

    .delegate '[contentEditable]',
      keydown: is_editable (event) ->
        $el = $ this
        text = $el.text()
        save this, text if unsaved this
        switch event.keyCode
          when 8 # backspace
            event.preventDefault() if text is ''
          when 13 # enter
            event.preventDefault()
            save this, $el.text()
            # Trigger custom event.
            $el.trigger 'contentedited'
          when 27 # escape
            $el.text last_saved this
            $el.blur()
      blur: is_editable ->
        $el = $ this
        # Restore saved text.
        $el.text last_saved this unless $el.data 'save-on-blur'
        # Work around contenteditable focus bug in WebKit, as suggested
        # in [gist #1081133](https://gist.github.com/1081133).
        $input[0].setSelectionRange 0, 0
        $input.blur()
