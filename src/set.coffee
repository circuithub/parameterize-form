  writeParameter = (els, value) ->
    if not Array.isArray value
      if els.length != 1 then throw "Value provided #{value} cannot populate #{els.length} fields."
      els[0].value = value
    else
      for el, i in els
        if not value?[i]? then throw "No value at index #{i} in [#{value}]"
        el.value = value[i]
    return

  writeTolerance = (els, value) ->
    minMax = [value.min, value.max]
    [min,max] = minMax
    if not Array.isArray min
      if els.length != 2 then throw "Value provided {min: #{min}, max: #{max}} cannot populate #{els.length} fields."
      els[0].value = min
      els[1].value = max
    else
      for el, i in els
        j = Math.floor (i / 2)
        if not minMax[i % 2]?[j]? then throw "No value at index #{j} in [#{minMax[i % 2]}]"
        el.value = minMax[i % 2][j]
    return

  parameterWriter = (adt
      Array: (array) -> (values, it) -> ((parameterWriter a) values, it) for a in array ; return
      parameters: (description, params...) -> @ params
      section: (heading, params...) -> @ params

      tolerance: (tolerances...) ->
        (values, it) ->
          writer = (param) -> (values, it) ->
            el = it.nextNode()
            value = values[el.getAttribute 'data-param-id']
            #writeTolerance[param._tag] (el.querySelectorAll "input"), value
            writeTolerance (el.querySelectorAll "input"), value
          ((writer t) values, it) for t in tolerances
          return

      boolean: -> (values, it) ->
        el = it.nextNode()
        els = el.querySelectorAll "input"
        if els.length > 1 then throw "Too many input elements for boolean argument."
        els[0].checked = values[el.getAttribute 'data-param-id']

      _: -> tag = @_tag ; (values, it) ->
        el = it.nextNode()
        value = values[el.getAttribute 'data-param-id']
        #writeParameter[tag] (el.querySelectorAll "input,select"), value
        writeParameter (el.querySelectorAll "input,select"), value
        return
    )

  module.exports = (formElement, parameters, values) ->
    # shim for the html5 selectors api level 2
    matches = (node,args...) -> (node.matches ? node.mozMatchesSelector ? node.webkitMatchesSelector).apply node, args

    # Create an iterator over the relevant parameter nodes
    selector = ".parameter"
    it = document.createNodeIterator formElement, NodeFilter.SHOW_ELEMENT, acceptNode: (node) -> if matches node, selector then NodeFilter.FILTER_ACCEPT else NodeFilter.FILTER_SKIP
    # Apply a form writer using the iterator
    writer = parameterWriter parameters
    writer values, it
    return
