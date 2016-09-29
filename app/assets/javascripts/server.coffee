$ ->
  $('.domain').on 'click', (e) ->

    e.preventDefault()
    clipboard = new Clipboard('.domain')

    clipboard.on 'success', (e) ->
      console.log e
      return

    clipboard.on 'error', (e) ->
      console.log e
      return
    return