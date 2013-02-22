adt = adt ? {} # require 'adt.js'
adt.html = adt.html ? require 'adt-html.js'

# Aliases

module.exports = (parameters) ->
  (->
    @div {class: "param-collection"},
      @h1 {class: "param-heading"}, "Some parameters"
      @span {class: "param-numeric"},
        @label {class: "param-label"}, "Label for input:"
        @input {class: "param-input"}
  ).call adt.html