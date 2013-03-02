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
  form.on = (eventKey, callback) ->
    # TODO

  # Export this module for nodejs
  module.exports = form

) (adt ? require 'adt.js')
