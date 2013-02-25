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

  option: (label, description, options, defaultKey) ->
    keyValue = {}
    options = if Array.isArray options
      (keyValue[k] = k) for k in options
    else
      keyValue = options

    defaultKey ?= (Object.keys keyValue)[0]

    html.div {class: 'param-real', title: (escapeAttrib description), 'data-placement': 'right'},
      html.label {class: "param-label"}, String label
      html.select {class: "param-select"},
        (for k,v of keyValue
          html.option {value: k, selected: (if k == defaultKey then true else undefined)}, v
        )...
}

) (adt ? require 'adt.js'), (html ? require 'adt-html.js')
