((adt, html) ->

module.exports = adt {
  real: ->
    html.div {class: "param-collection"},
      html.h1 {class: "param-heading"}, "Some parameters"
      html.span {class: "param-numeric"},
        html.label {class: "param-label"}, "Label for input:"
        html.input {class: "param-input"}    
}
) (adt ? require 'adt.js'), (html ? require 'adt-html.js')

