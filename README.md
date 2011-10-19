# contenteditable

contenteditable is a tiny jQuery utility which adds useful behaviour to
`contenteditable` text.

## Usage

The element with the `contenteditable` attribute must be wrapped by an element
with a class of `contenteditable`. To make an `h1` editable, for example, use:

```html
<h1 class=contenteditable><span contenteditable>Romeo & Juliet</span></h1>
```

When a user clicks the editable text the browser inserts the caret as near as
possible to the cursor. contenteditable also listens for click events on the
containing element (the `h1` in the above example). The event handler focuses
the editable element and selects its text. To take advantage of this handler,
include CSS similar to the following:

```css
.contenteditable {
  display: inline-block;
  background: url(images/edit.png) no-repeat right;
  padding-right: 24px;
}
```

contenteditable also listens for the enter/return keystroke when text is being
edited, in response to which it triggers a "contentedited" event. This custom
event provides a hook for application code, which might be along these lines:

```javascript
$('#play').bind('contentedited', function (event) {
  $.post('/path/to/resource', {title: $(event.target).text()})
})
```
