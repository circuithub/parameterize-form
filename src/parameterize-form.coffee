adt = require "adt.js"
adt.html = require "adt-html.js"

# Aliases

module.exports = (parameters) ->
  (->
    @div {class: "param-collection"},
      @h1 {class: "param-heading"}
      @span {class: "param-numeric"},
        @label {class: "param-label"}
        @input {class: "param-input"}
  ).call adt.html