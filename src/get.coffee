  readUnit =
    real: (els) -> Number els[0].value
    integer: (els) -> Math.round readUnit.real els
    natural: (els) -> Math.max 0, Math.round readUnit.integer els
    meter: (els) -> readUnit.real els
    meter2: (els) -> [(readUnit.meter [els[0]]), (readUnit.meter [els[1]])]
    meter3: (els) -> [(readUnit.meter [els[0]]), (readUnit.meter [els[1]]), (readUnit.meter [els[2]])]
    degree: (els) -> readUnit.real els

  readParameter =
    real: readUnit.real
    dimension1: readUnit.meter
    dimension2: readUnit.meter2
    dimension3: readUnit.meter3
    vector2: readUnit.meter2
    vector3: readUnit.meter3
    point2: readUnit.meter2
    point3: readUnit.meter3
    pitch1: readUnit.meter
    pitch2: readUnit.meter2
    pitch3: readUnit.meter3
    angle: readUnit.degree
    polar: (els) -> [
      readUnit.meter [els[0]]
      readUnit.degree [els[1]]
    ]
    cylindrical: (els) -> [
      readUnit.meter [els[0]]
      readUnit.degree [els[1]]
      readUnit.meter [els[2]]
    ]
    spherical: (els) -> [
      readUnit.meter [els[0]]
      readUnit.degree [els[1]]
      readUnit.degree [els[2]]
    ]
    integer: readUnit.integer
    natural: readUnit.natural
    latice1: readUnit.natural
    latice2: (els) -> [
      readUnit.natural [els[0]]
      readUnit.natural [els[1]]
    ]
    latice3: (els) -> [
      readUnit.natural [els[0]]
      readUnit.natural [els[1]]
      readUnit.natural [els[2]]
    ]
    boolean: (els) -> Boolean els[0].checked
    option: (els) -> els[0].options[els[0].selectedIndex].value

  readToleranceWith =
    '1': (f) -> (els) ->
      min: f [els[0]]
      max: f [els[1]]
    '2': (f) -> (els) ->
      min: [ (f [els[0]]), (f [els[2]]) ]
      max: [ (f [els[1]]), (f [els[3]]) ]
    '3': (f) -> (els) ->
      min: [ (f [els[0]]), (f [els[2]]), (f [els[4]]) ]
      max: [ (f [els[1]]), (f [els[3]]), (f [els[5]]) ]

  readTolerance =
    real: readToleranceWith['1'] readUnit.real
    dimension1: readToleranceWith['1'] readUnit.meter
    dimension2: readToleranceWith['2'] readUnit.meter
    dimension3: readToleranceWith['3'] readUnit.meter
    vector2: readToleranceWith['2'] readUnit.meter
    vector3: readToleranceWith['3'] readUnit.meter
    point2: readToleranceWith['2'] readUnit.meter
    point3: readToleranceWith['3'] readUnit.meter
    pitch1: readToleranceWith['1'] readUnit.meter
    pitch2: readToleranceWith['2'] readUnit.meter
    pitch3: readToleranceWith['3'] readUnit.meter
    angle: readToleranceWith['1'] readUnit.degree
    polar: (els) -> [
      (readToleranceWith['1'] readUnit.meter) els[0..1]
      (readToleranceWith['1'] readUnit.degree) els[2..]
    ]
    cylindrical: (els) -> [
      (readToleranceWith['1'] readUnit.meter) els[0..1]
      (readToleranceWith['1'] readUnit.degree) els[2..3]
      (readToleranceWith['1'] readUnit.meter) els[4..]
    ]
    spherical: (els) -> [
      (readToleranceWith['1'] readUnit.meter) els[0..1]
      (readToleranceWith['1'] readUnit.degree) els[2..3]
      (readToleranceWith['1'] readUnit.degree) els[4..]
    ]

  parameterReader = (adt
      Array: (array) -> (result, it) -> ((parameterReader a) result, it) for a in array ; return
      parameters: (description, params...) -> @ params
      section: (heading, params...) -> @ params

      tolerance: (tolerances...) -> 
        (result, it) ->
          reader = (param) -> (result, it) ->
            el = it.nextNode()
            result[el.getAttribute('data-param-id')] = readTolerance[param._tag] el.querySelectorAll "input"
          ((reader t) result, it) for t in tolerances
          return

      _: -> tag = @_tag ; (result, it) ->
        el = it.nextNode()
        result[el.getAttribute('data-param-id')] = readParameter[tag] el.querySelectorAll "input,select"
        return
    )

  module.exports = (formElement, parameters) ->
    # shim for the html5 selectors api level 2
    matches = (node,args...) -> (node.matches ? node.mozMatchesSelector ? node.webkitMatchesSelector).apply node, args
    # Create an iterator over the relevant input nodes
    #selector = "input,select"
    # Create an iterator over the relevant parameter nodes
    selector = ".parameter"
    it = document.createNodeIterator formElement, NodeFilter.SHOW_ELEMENT, acceptNode: (node) -> if matches node, selector then NodeFilter.FILTER_ACCEPT else NodeFilter.FILTER_SKIP
    # Apply a form reader using the iterator
    reader = parameterReader parameters
    result = {}
    reader result, it
    return result
