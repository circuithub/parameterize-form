((adt, html) ->

  wrap = -> html.div {class: 'parameter'}, arguments...
  escapeAttrib = (str) -> (String str).replace /['"]/gi, "`"

  toleranceHTML = adt {
    real: (label, description, defaultTolerance) ->
      wrap html.div {class: "param-real", title: (escapeAttrib description)},
        html.label {class: "param-label"}, 
          html.span {class: "param-label-text"}, String label
          html.span {class: "param-real param-tolerance-min"}, html.input {class: "param-input", value: String defaultTolerance.min}
          html.span {class: "param-real param-tolerance-max"}, html.input {class: "param-input", value: String defaultTolerance.max}
    _: -> throw "Unsupported tolerance type `#{this._tag}`"
  }

  module.exports = adt {
    parameters: (description, children...) -> 
      html.div {class: "parameters"}, (adt.map @, children)...

    section: (heading, children...) ->
      wrap html.section {class: "param-section"},
        html.h2 {class: "param-header"}, String heading
        (adt.map @, children)...

    real: (label, description, defaultValue) ->
      wrap html.div {class: "param-real", title: (escapeAttrib description)},
        html.label {class: "param-label"},
          html.span {class: "param-label-text"}, String label
          html.input {class: "param-input", value: String defaultValue}

    option: (label, description, options, defaultOption) ->
      keyValue = {}
      options = if Array.isArray options
        (keyValue[k] = k) for k in options
      else
        keyValue = options

      defaultOption ?= (Object.keys keyValue)[0]

      wrap html.div {class: "param-real", title: (escapeAttrib description)},
        html.label {class: "param-label"},
          html.span {class: "param-label-text"}, String label
          html.select {class: "param-select"},
            (for k,v of keyValue
              html.option {value: k, selected: (if k == defaultOption then true else undefined)}, v
            )...

    boolean: (label, description, defaultValue) ->
      wrap html.div {class: "param-boolean", title: (escapeAttrib description)},
        html.label {class: "param-label"}, 
          html.input {type: "checkbox", class: "param-checkbox"}
          html.span String label

    tolerances: (tolerances...) ->
      html.div {class: "param-tolerance-table"},
        html.div {class: "param-tolerance-legend"},
          html.span {class: "param-tolerance-legend-label"}, "Min"
          html.span {class: "param-tolerance-legend-label"}, "Max"
        html.div {class: "param-tolerance-body"},
          (adt.map toleranceHTML, tolerances)...

    _: -> throw "Unsupported parameter type `#{this._tag}`"
  }

) (adt ? require 'adt.js'), (html ? require 'adt-html.js')
