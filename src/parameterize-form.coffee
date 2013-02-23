((adt, html) ->

escapeAttrib = (str) -> (String str).replace /['"]/gi, "`"

module.exports = adt {
  section: (heading, children...) ->
    html.section {class: 'param-section'}, 
      html.h2 {class: 'param-header'}, String heading
      children...

  real: (label, description, value) ->
    html.div {class: 'param-real', title: (escapeAttrib description), 'data-placement': 'right'},
      html.label {class: "param-label"}, String label
      html.input {class: "param-input"}

  select: (label, description, value) ->
    html.div {class: 'param-real', title: (escapeAttrib description), 'data-placement': 'right'},
      html.label {class: "param-label"}, String label
      html.span "  - TODO"
}
) (adt ? require 'adt.js'), (html ? require 'adt-html.js')
