((adt, html) ->

  # Constants
  shortLabelLength = 5 

  # Helpers
  escapeAttrib = (str) -> (String str).replace /['"]/gi, "`"
  
  # HTML helpers
  wrap = -> html.div {class: "parameter clearfix"}, arguments...
  wrapComposite = -> html.div {class: "parameter param-composite clearfix"}, arguments...
  wrapTolerance = -> html.div {class: "parameter param-tolerance clearfix"}, arguments...
  
  labeledElements = (label, elements...) ->
    html.label {class: "param-label"}, 
      html.span {class: "param-label-text"}, String label
      elements...
  labeledInput = (label, value) ->
    labeledElements label, 
      html.input {class: "param-input", value: String value}
  labeledInputs = (n, labels, values, shortLabels = false) ->
    if not shortLabels
      (labeledInput labels[i], values[i]) for i in [0...n]
    else
      [
        html.table {class: "param-composite-table"},
          html.thead {class: "param-composite-thead"},
            html.tr {class: "param-composite-thead-tr"},
              (for i in [0...n]
                html.th {class: "param-composite-th"}, labeledElements labels[i])...
          html.tbody {class: "param-composite-tbody"},
            html.tr {class: "param-composite-tr"},
              (for i in [0...n]
                html.td {class: "param-composite-td"}, html.input {class: "param-input", value: String values[i]})...
      ]
  labeledToleranceInput = (label, tolerance) ->
    labeledElements label, 
      html.input {class: "param-input", value: String tolerance.min}
      html.input {class: "param-input", value: String tolerance.max}
  labeledToleranceInputs = (n, labels, tolerances) ->
    (labeledToleranceInput labels[i], {min: tolerances.min[i], max: tolerances.max[i]}) for i in [0...n]
  toleranceTable = (elements...) ->
    html.div {class: "param-tolerance-table"},
      html.div {class: "param-tolerance-legend"},
        html.span {class: "param-tolerance-legend-label"}, "Min"
        html.span {class: "param-tolerance-legend-label"}, "Max"
      html.div {class: "param-tolerance-body"}, elements...

  # Toleranced values
  toleranceHTML = adt {
    real: (id, meta, defaultTolerance) ->
      if typeof meta == 'string' then meta = {label: meta}
      else if not meta? then meta = {label: id}
      else if not meta.label? then meta.label = id
      meta.description ?= ""
      wrapTolerance html.div {class: "param-numeric param-real", title: (escapeAttrib meta.description)},
        labeledToleranceInput meta.label, defaultTolerance
    dimension1: (id, meta, defaultTolerance) ->
      if typeof meta == 'string' then meta = {label: meta}
      else if not meta? then meta = {label: id}
      else if not meta.label? then meta.label = id
      meta.description ?= ""
      wrapTolerance html.div {class: "param-numeric param-real", title: (escapeAttrib meta.description)},
        labeledToleranceInput meta.label, defaultTolerance
    dimension2: (id, meta, defaultTolerance) ->
      if typeof meta == 'string' then meta = {label: meta}
      else if not meta? then meta = {label: id}
      else if not meta.label? then meta.label = id
      meta.description ?= ""
      meta.components ?= ["X","Y"]
      if not Array.isArray defaultTolerance.min then defaultTolerance.min = [defaultTolerance.min, defaultTolerance.min, defaultTolerance.min]
      if not Array.isArray defaultTolerance.max then defaultTolerance.max = [defaultTolerance.max, defaultTolerance.max, defaultTolerance.max]
      wrapTolerance html.div {class: "param-numeric param-dimension3", title: (escapeAttrib meta.description)},
        html.label {class: "param-composite-label"},
          html.span {class: "param-label-text"}, String meta.label
        (labeledToleranceInputs 2, meta.components, defaultTolerance)...
    dimension3: (id, meta, defaultTolerance) ->
      if typeof meta == 'string' then meta = {label: meta}
      else if not meta? then meta = {label: id}
      else if not meta.label? then meta.label = id
      meta.description ?= ""
      meta.components ?= ["X","Y","Z"]
      if not Array.isArray defaultTolerance.min then defaultTolerance.min = [defaultTolerance.min, defaultTolerance.min, defaultTolerance.min]
      if not Array.isArray defaultTolerance.max then defaultTolerance.max = [defaultTolerance.max, defaultTolerance.max, defaultTolerance.max]
      wrapTolerance html.div {class: "param-numeric param-dimension3", title: (escapeAttrib meta.description)},
        html.label {class: "param-composite-label"},
          html.span {class: "param-label-text"}, String meta.label
        toleranceTable (labeledToleranceInputs 3, meta.components, defaultTolerance)...
    vector2: -> throw "Unsupported tolerance type `#{this._tag}` (TODO)"
    vector3: -> throw "Unsupported tolerance type `#{this._tag}` (TODO)"
    point2: -> throw "Unsupported tolerance type `#{this._tag}` (TODO)"
    point3: -> throw "Unsupported tolerance type `#{this._tag}` (TODO)"
    pitch1: -> throw "Unsupported tolerance type `#{this._tag}` (TODO)"
    pitch2: -> throw "Unsupported tolerance type `#{this._tag}` (TODO)"
    pitch3: -> throw "Unsupported tolerance type `#{this._tag}` (TODO)"
    angle: -> throw "Unsupported tolerance type `#{this._tag}` (TODO)"
    polar: -> throw "Unsupported tolerance type `#{this._tag}` (TODO)"
    cylindrical: -> throw "Unsupported tolerance type `#{this._tag}` (TODO)"
    spherical: -> throw "Unsupported tolerance type `#{this._tag}` (TODO)"
    _: -> throw "Unsupported tolerance type `#{this._tag}`"
  }

  # Parameters
  module.exports = adt {
    parameters: (description, children...) -> 
      html.div {class: "parameters"}, (adt.map @, children)...

    section: (heading, children...) ->
      html.section {class: "param-section"},
        html.h1 {class: "param-heading"}, String heading
        (adt.map @, children)...

    real: (id, meta, defaultValue) ->
      if typeof meta == 'string' then meta = {label: meta}
      else if not meta? then meta = {label: id}
      else if not meta.label? then meta.label = id
      meta.description ?= ""
      wrap html.div {class: "param-numeric param-real", title: (escapeAttrib meta.description)},
        html.label {class: "param-label"},
          html.span {class: "param-label-text"}, String meta.label
          html.input {class: "param-input", value: String defaultValue}

    dimension1: (id, meta, defaultValue) ->
      if typeof meta == 'string' then meta = {label: meta}
      else if not meta? then meta = {label: id}
      else if not meta.label? then meta.label = id
      meta.description ?= ""
      wrap html.div {class: "param-numeric param-dimension1", title: (escapeAttrib meta.description)},
        html.label {class: "param-label"},
          html.span {class: "param-label-text"}, String meta.label
          html.input {class: "param-input", value: String defaultValue}

    dimension2: (id, meta, defaultValue) ->
      if typeof meta == 'string' then meta = {label: meta}
      else if not meta? then meta = {label: id}
      else if not meta.label? then meta.label = id
      meta.description ?= ""
      meta.components ?= ["X","Y"]
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length) < shortLabelLength
      if not Array.isArray defaultValue then defaultValue = [defaultValue, defaultValue]
      wrapComposite html.div {class: "param-numeric param-dimension2", title: (escapeAttrib meta.description)},
        html.label {class: "param-composite-label"},
          html.span {class: "param-label-text"}, String meta.label
        (labeledInputs 2, meta.components, defaultValue, shortLabels)...

    dimension3: (id, meta, defaultValue) ->
      if typeof meta == 'string' then meta = {label: meta}
      else if not meta? then meta = {label: id}
      else if not meta.label? then meta.label = id
      meta.description ?= ""
      meta.components ?= ["X","Y","Z"]
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length, meta.components[2].length) < shortLabelLength
      if not Array.isArray defaultValue then defaultValue = [defaultValue, defaultValue, defaultValue]
      wrapComposite html.div {class: "param-numeric param-dimension3", title: (escapeAttrib meta.description)},
        html.label {class: "param-composite-label"},
          html.span {class: "param-label-text"}, String meta.label
        (labeledInputs 3, meta.components, defaultValue, shortLabels)...

    vector2: -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    vector3: -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    point2: -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    point3: -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    pitch1: -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    pitch2: -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    pitch3: -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    angle: -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    polar: -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    cylindrical: -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    spherical: -> throw "Unsupported parameter type `#{this._tag}` (TODO)"
    
    integer: -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    natural: -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    latice1: -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    latice2: -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    latice3: -> throw "Unsupported parameter type `#{this._tag}` (TODO)"
    
    option: (id, meta, options, defaultOption) ->
      if typeof meta == 'string' then meta = {label: meta}
      else if not meta? then meta = {label: id}
      else if not meta.label? then meta.label = id
      meta.description ?= ""
      keyValue = {}
      options = if Array.isArray options
        (keyValue[k] = k) for k in options
      else
        keyValue = options

      defaultOption ?= (Object.keys keyValue)[0]

      wrap html.div {class: "param-numeric param-real", title: (escapeAttrib meta.description)},
        labeledElements meta.label,
          html.select {class: "param-select"},
            (for k,v of keyValue
              html.option {value: k, selected: (if k == defaultOption then true else undefined)}, v
            )...

    boolean: (id, meta, defaultValue) ->
      if typeof meta == 'string' then meta = {label: meta}
      else if not meta? then meta = {label: id}
      else if not meta.label? then meta.label = id
      meta.description ?= ""
      wrap html.div {class: "param-boolean", title: (escapeAttrib meta.description)},
        labeledElements meta.label, html.input {type: "checkbox", class: "param-checkbox"}

    tolerance: (tolerance) ->
      toleranceHTML tolerance

    range: (id, meta, defaultValue, range) ->
      throw "Unsupported parameter type `#{this._tag}` (TODO)"

    _: -> throw "Unsupported parameter type `#{this._tag}`"
  }

) (adt ? require 'adt.js'), (html ? require 'adt-html.js')
