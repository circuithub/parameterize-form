((adt, html) ->

  # Constants
  shortLabelLength = 5 

  # Helpers
  escapeAttrib = (str) -> (String str).replace /['"]/gi, "`"
  groupByTolerance = (as) ->
    gs = [] # groups
    for a in as
      if a._tag == 'tolerance' and gs[gs.length-1]?._tag == 'tolerance'
        gs[gs.length-1].push a...
      else
        gs.push a
    return gs
  
  # HTML helpers
  wrap = -> html.div {class: "parameter"}, arguments...
  wrapComposite = (classes, description, args...) -> html.div {class: "parameter param-composite #{classes}", title: escapeAttrib description}, args...
  
  labeledElements = (label, elements...) ->
    html.label {class: "param-label"}, 
      html.span {class: "param-label-text"}, String label
      elements...
  labeledInput = (label, value) ->
    labeledElements label, 
      html.input {class: "param-input", value: String value}
  # TODO: rename to labeledComposite
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
  labeledTolerance = (label, tolerance) -> 
    [
      html.th {class: "param-tolerance-th", scope: "row"}, html.label {class: "param-label"}, label
      html.td html.input {class: "param-input", value: String tolerance.min}
      html.td html.input {class: "param-input", value: String tolerance.max}
    ]
  labeledCompositeTolerance = (n, labels, tolerances) ->
    (labeledTolerance labels[i], {min: tolerances.min[i], max: tolerances.max[i]}) for i in [0...n]

  # Toleranced values
  toleranceHTML = adt {
    real: (id, meta, defaultTolerance) ->
      if typeof meta == 'string' then meta = {label: meta}
      else if not meta? then meta = {label: id}
      else if not meta.label? then meta.label = id
      meta.description ?= ""
      html.tr {class: "parameter param-numeric param-real", title: escapeAttrib meta.description},
        (labeledTolerance meta.label, defaultTolerance)...
    dimension1: (id, meta, defaultTolerance) ->
      if typeof meta == 'string' then meta = {label: meta}
      else if not meta? then meta = {label: id}
      else if not meta.label? then meta.label = id
      meta.description ?= ""
      html.tr {class: "parameter param-numeric param-dimension1", title: escapeAttrib meta.description},
        (labeledTolerance meta.label, defaultTolerance)...
    dimension2: (id, meta, defaultTolerance) ->
      if typeof meta == 'string' then meta = {label: meta}
      else if not meta? then meta = {}
      meta.description ?= ""
      meta.components ?= ["X","Y"]
      if not Array.isArray defaultTolerance.min then defaultTolerance.min = [defaultTolerance.min, defaultTolerance.min, defaultTolerance.min]
      if not Array.isArray defaultTolerance.max then defaultTolerance.max = [defaultTolerance.max, defaultTolerance.max, defaultTolerance.max]
      trs = if not meta.label? then [] else 
        [html.tr html.th {class: "", colspan: 3, scope: "rowgroup"}, escapeAttrib meta.label]
      trs = trs.concat (for tds in (labeledCompositeTolerance 2, meta.components, defaultTolerance)
        html.tr {class: "param-numeric"}, tds...)
      html.tbody {class: "parameter param-composite param-dimension2", title: escapeAttrib meta.description},
        trs...
        
    dimension3: (id, meta, defaultTolerance) ->
      if typeof meta == 'string' then meta = {label: meta}
      else if not meta? then meta = {label: id}
      else if not meta.label? then meta.label = id
      meta.description ?= ""
      meta.components ?= ["X","Y","Z"]
      if not Array.isArray defaultTolerance.min then defaultTolerance.min = [defaultTolerance.min, defaultTolerance.min, defaultTolerance.min]
      if not Array.isArray defaultTolerance.max then defaultTolerance.max = [defaultTolerance.max, defaultTolerance.max, defaultTolerance.max]
      trs = if not meta.label? then [] else 
        [html.tr html.th {class: "", colspan: 3, scope: "rowgroup"}, escapeAttrib meta.label]
      trs = trs.concat (for tds in (labeledCompositeTolerance 3, meta.components, defaultTolerance)
        html.tr {class: "param-numeric"}, tds...)
      html.tbody {class: "parameter param-composite param-dimension3", title: escapeAttrib meta.description},
        trs...
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

  resolveMeta = (id, meta) -> 
    if typeof meta == 'string' then meta = {label: meta}
    else if not meta? then meta = {label: id}
    else meta.label ?= id
    meta.description ?= ""
    return meta

  # Parameters
  module.exports = adt {
    parameters: (description, children...) -> 
      html.div {class: "parameters"}, (adt.map @, children)...

    section: (heading, children...) ->
      html.section {class: "param-section"},
        html.h1 {class: "param-heading"}, String heading
        (adt.map @, groupByTolerance children)...

    real: (id, meta, defaultValue) ->
      meta = resolveMeta id, meta
      wrap html.div {class: "param-numeric param-real", title: (escapeAttrib meta.description)},
        html.label {class: "param-label"},
          html.span {class: "param-label-text"}, String meta.label
          html.input {class: "param-input", value: String defaultValue}

    dimension1: (id, meta, defaultValue) ->
      meta = resolveMeta id, meta
      wrap html.div {class: "param-numeric param-dimension1", title: (escapeAttrib meta.description)},
        html.label {class: "param-label"},
          html.span {class: "param-label-text"}, String meta.label
          html.input {class: "param-input", value: String defaultValue}

    dimension2: (id, meta, defaultValue) ->
      meta = resolveMeta id, meta
      meta.components ?= ["X","Y"]
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length) < shortLabelLength
      if not Array.isArray defaultValue then defaultValue = [defaultValue, defaultValue]
      wrapComposite "param-numeric param-dimension2", meta.description,
        html.label {class: "param-composite-label"},
          html.span {class: "param-label-text"}, String meta.label
        (labeledInputs 2, meta.components, defaultValue, shortLabels)...

    dimension3: (id, meta, defaultValue) ->
      meta = resolveMeta id, meta
      meta.components ?= ["X","Y","Z"]
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length, meta.components[2].length) < shortLabelLength
      if not Array.isArray defaultValue then defaultValue = [defaultValue, defaultValue, defaultValue]
      wrapComposite "param-numeric param-dimension3", meta.description,
        html.label {class: "param-composite-label"},
          html.span {class: "param-label-text"}, String meta.label
        (labeledInputs 3, meta.components, defaultValue, shortLabels)...

    vector2: (id, meta, defaultValue) ->
      meta = resolveMeta id, meta
      meta.components ?= ["X","Y"]
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length) < shortLabelLength
      if not Array.isArray defaultValue then defaultValue = [defaultValue, defaultValue]
      wrapComposite "param-numeric param-vector2", meta.description,
        html.label {class: "param-composite-label"},
          html.span {class: "param-label-text"}, String meta.label
        (labeledInputs 2, meta.components, defaultValue, shortLabels)...

    vector3: (id, meta, defaultValue) ->
      meta = resolveMeta id, meta
      meta.components ?= ["X","Y","Z"]
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length, meta.components[2].length) < shortLabelLength
      if not Array.isArray defaultValue then defaultValue = [defaultValue, defaultValue, defaultValue]
      wrapComposite "param-numeric param-vector3", meta.description,
        html.label {class: "param-composite-label"},
          html.span {class: "param-label-text"}, String meta.label
        (labeledInputs 3, meta.components, defaultValue, shortLabels)...

    point2: (id, meta, defaultValue) ->
      meta = resolveMeta id, meta
      meta.components ?= ["X","Y"]
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length) < shortLabelLength
      if not Array.isArray defaultValue then defaultValue = [defaultValue, defaultValue]
      wrapComposite "param-numeric param-point2", meta.description,
        html.label {class: "param-composite-label"},
          html.span {class: "param-label-text"}, String meta.label
        (labeledInputs 2, meta.components, defaultValue, shortLabels)...

    point3: (id, meta, defaultValue) ->
      meta = resolveMeta id, meta
      meta.components ?= ["X","Y","Z"]
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length, meta.components[2].length) < shortLabelLength
      if not Array.isArray defaultValue then defaultValue = [defaultValue, defaultValue, defaultValue]
      wrapComposite "param-numeric param-point3", meta.description,
        html.label {class: "param-composite-label"},
          html.span {class: "param-label-text"}, String meta.label
        (labeledInputs 3, meta.components, defaultValue, shortLabels)...

    pitch1: (id, meta, defaultValue) ->
      meta = resolveMeta id, meta
      wrap html.div {class: "param-numeric param-pitch1", title: (escapeAttrib meta.description)},
        html.label {class: "param-label"},
          html.span {class: "param-label-text"}, String meta.label
          html.input {class: "param-input", value: String defaultValue}

    pitch2: (id, meta, defaultValue) ->
      meta = resolveMeta id, meta
      meta.components ?= ["X","Y"]
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length) < shortLabelLength
      if not Array.isArray defaultValue then defaultValue = [defaultValue, defaultValue]
      wrapComposite "param-numeric param-pitch2", meta.description,
        html.label {class: "param-composite-label"},
          html.span {class: "param-label-text"}, String meta.label
        (labeledInputs 2, meta.components, defaultValue, shortLabels)...

    pitch3: (id, meta, defaultValue) ->
      meta = resolveMeta id, meta
      meta.components ?= ["X","Y","Z"]
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length, meta.components[2].length) < shortLabelLength
      if not Array.isArray defaultValue then defaultValue = [defaultValue, defaultValue, defaultValue]
      wrapComposite "param-numeric param-pitch3", meta.description,
        html.label {class: "param-composite-label"},
          html.span {class: "param-label-text"}, String meta.label
        (labeledInputs 3, meta.components, defaultValue, shortLabels)...

    angle: (id, meta, defaultValue) -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    polar: (id, meta, defaultValue) -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    cylindrical: (id, meta, defaultValue) -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    spherical: (id, meta, defaultValue) -> throw "Unsupported parameter type `#{this._tag}` (TODO)"
    
    integer: (id, meta, defaultValue) -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    natural: (id, meta, defaultValue) -> throw "Unsupported parameter type `#{this._tag}` (TODO)"

    latice1: (id, meta, defaultValue) ->
      meta = resolveMeta id, meta
      wrap html.div {class: "param-numeric param-latice1", title: (escapeAttrib meta.description)},
        html.label {class: "param-label"},
          html.span {class: "param-label-text"}, String meta.label
          html.input {class: "param-input", value: String defaultValue}

    latice2: (id, meta, defaultValue) ->
      meta = resolveMeta id, meta
      meta.components ?= ["X","Y"]
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length) < shortLabelLength
      if not Array.isArray defaultValue then defaultValue = [defaultValue, defaultValue]
      wrapComposite "param-numeric param-latice2", meta.description,
        html.label {class: "param-composite-label"},
          html.span {class: "param-label-text"}, String meta.label
        (labeledInputs 2, meta.components, defaultValue, shortLabels)...

    latice3: (id, meta, defaultValue) ->
      meta = resolveMeta id, meta
      meta.components ?= ["X","Y","Z"]
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length, meta.components[2].length) < shortLabelLength
      if not Array.isArray defaultValue then defaultValue = [defaultValue, defaultValue, defaultValue]
      wrapComposite "param-numeric param-latice3", meta.description,
        html.label {class: "param-composite-label"},
          html.span {class: "param-label-text"}, String meta.label
        (labeledInputs 3, meta.components, defaultValue, shortLabels)...
    
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

    tolerance: (tolerances...) ->
      if tolerances.length == 0
        return
      rowgroups = adt.map toleranceHTML, tolerances
      # Group tr tags into tbody tags
      tbodies = []
      ii = NaN
      for rowgroup,i in rowgroups
        if rowgroup._tag == "tr"
          if ii == i - 1
            tbodies[tbodies.length - 1].push rowgroup
          else
            tbodies.push (html.tbody {class: ""}, rowgroup)
          ii = i
        else
          tbodies.push rowgroup
      html.table {class: "param-tolerance-table"},
        html.thead {class: "param-tolerance-thead"},
          html.tr {class: "param-tolerance-legend"},
            html.th {class: "param-tolerance-th"}
            html.th {class: "param-tolerance-th"}, "Min"
            html.th {class: "param-tolerance-th"}, "Max"
        tbodies...
        

    range: (id, meta, defaultValue, range) ->
      throw "Unsupported parameter type `#{this._tag}` (TODO)"

    _: -> throw "Unsupported parameter type `#{this._tag}`"
  }

) (adt ? require 'adt.js'), (html ? require 'adt-html.js')
