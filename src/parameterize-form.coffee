((adt) ->

  form = html: require "html"

  # ADT constructors for a form
  form.form = adt.constructors form.html

  # Convert the given form element into a json structure
  # Also performs validation and conversions on the form elements
  form.get = (formElement) ->
    # TODO

  # Convert the given values into a form 
  form.set = (formElement, form) ->
    # TODO

  # Event handlers
  form.on = (eventKey, selector, callback) ->
    if not $?
      throw "JQuery could not be found. Please ensure that $ is available before using parameterize.on."
    $(selector).on 'change', 'input', callback
    return

  # Export this module for nodejs
  module.exports = form

) (adt ? require 'adt.js')
