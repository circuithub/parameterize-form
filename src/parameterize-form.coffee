((adt) ->

  form = html: require "html"

  # ADT constructors for a form
  form.form = adt.constructors form.html

  # Convert the given form element into a json structure
  # Also performs validation and conversions on the form elements
  form.get = require "./get"

  # Set the html element inputs to values stored in the json structure
  form.set = require "./set"

  # Event handlers
  form.on = (eventKey, selector, callback) ->
    if not $?
      throw "JQuery could not be found. Please ensure that $ is available before using parameterize.on."
    if eventKey != "update" 
      throw "Unknown event key \'#{eventKey}\'."

    # TODO: on loose focus, reset input contents to converted units
    $selector = $ selector
    $selector.on 'change', 'input[type="checkbox"],select', callback
    # Handle printable characters
    $selector.on 'keypress', 'input[type="text"]', (e) ->
      if e.which == 0
        return
      callback arguments...
      return
    # Handle non-printable characters
    $selector.on 'keydown', 'input[type="text"]', (e) ->
      if e.which == 0
        return
      switch e.which
        when 8, 46    # Backspace, Delete
          undefined
        when 45       # Shift + Insert
          if not e.shiftKey then return
        when 86, 88   # Ctrl + V, X
          if not e.ctrlKey then return
        else
          return
      callback arguments...
      return
    return

  # Event handlers
  form.off = (eventKey, selector) ->  #, callback
    if not $?
      throw "JQuery could not be found. Please ensure that $ is available before using parameterize.off."
    if eventKey != "update" 
      throw "Unknown event key \'#{eventKey}\'."

    # TODO: on loose focus, reset input contents to converted units
    $selector = $ selector
    $selector.off 'change', 'input[type="checkbox"],select' #, callback
    # Handle printable characters
    $selector.off 'keypress', 'input[type="text"]'
    # Handle non-printable characters
    $selector.off 'keydown', 'input[type="text"]'
    return

  # Export this module for nodejs
  module.exports = form

) (adt ? require 'adt.js')
