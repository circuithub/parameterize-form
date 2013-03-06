/*
 * Copyright 2013, CircuitHub.com
 */
var parameterize = parameterize || {}; /* Redeclaring parameterize is fine: behaves like a no-op (https://developer.mozilla.org/en/JavaScript/Reference/Scope_Cheatsheet) */
(function(){
var originalRequire = this.require || (void 0);


(function(/*! Stitch !*/) {
  if (!this.require) {
    var modules = {}, cache = {}, require = function(name, root) {
      var path = expand(root, name), module = cache[path], fn;
      if (module) {
        return module.exports;
      } else if (fn = modules[path] || modules[path = expand(path, './index')]) {
        module = {id: path, exports: {}};
        try {
          cache[path] = module;
          fn(module.exports, function(name) {
            return require(name, dirname(path));
          }, module);
          return module.exports;
        } catch (err) {
          delete cache[path];
          throw err;
        }
      } else {
        throw 'module \'' + name + '\' not found';
      }
    }, expand = function(root, name) {
      var results = [], parts, part;
      if (/^\.\.?(\/|$)/.test(name)) {
        parts = [root, name].join('/').split('/');
      } else {
        parts = name.split('/');
      }
      for (var i = 0, length = parts.length; i < length; i++) {
        part = parts[i];
        if (part == '..') {
          results.pop();
        } else if (part != '.' && part != '') {
          results.push(part);
        }
      }
      return results.join('/');
    }, dirname = function(path) {
      return path.split('/').slice(0, -1).join('/');
    };
    this.require = function(name) {
      return require(name, '');
    }
    this.require.define = function(bundle) {
      for (var key in bundle) {
        modules[key] = bundle[key];
        var ext = key.split('.').pop();
        if (ext.indexOf('/') === -1 && ext.length < key.length)
          modules[key.slice(0,-ext.length - 1)] = bundle[key];
      }
    };
  }
  return this.require.define;
}).call(this)({"html.js": function(exports, require, module) {// Generated by CoffeeScript 1.4.0
var __slice = [].slice;

(function(adt, html) {
  var escapeAttrib, groupByTolerance, labeledCompositeTolerance, labeledElements, labeledInput, labeledInputs, labeledTolerance, resolveMeta, shortLabelLength, toleranceHTML, wrap, wrapComposite;
  shortLabelLength = 5;
  escapeAttrib = function(str) {
    return (String(str)).replace(/['"]/gi, "`");
  };
  groupByTolerance = function(as) {
    var a, gs, _i, _len, _ref, _ref1;
    gs = [];
    for (_i = 0, _len = as.length; _i < _len; _i++) {
      a = as[_i];
      if (a._tag === 'tolerance' && ((_ref = gs[gs.length - 1]) != null ? _ref._tag : void 0) === 'tolerance') {
        (_ref1 = gs[gs.length - 1]).push.apply(_ref1, a);
      } else {
        gs.push(a);
      }
    }
    return gs;
  };
  wrap = function() {
    return html.div.apply(html, [{
      "class": "parameter"
    }].concat(__slice.call(arguments)));
  };
  wrapComposite = function() {
    var args, classes, description;
    classes = arguments[0], description = arguments[1], args = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
    return html.div.apply(html, [{
      "class": "parameter param-composite " + classes,
      title: escapeAttrib(description)
    }].concat(__slice.call(args)));
  };
  labeledElements = function() {
    var elements, label;
    label = arguments[0], elements = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    return html.label.apply(html, [{
      "class": "param-label"
    }, html.span({
      "class": "param-label-text"
    }, String(label))].concat(__slice.call(elements)));
  };
  labeledInput = function(label, value) {
    return labeledElements(label, html.input({
      "class": "param-input",
      type: 'text',
      value: String(value)
    }));
  };
  labeledInputs = function(n, labels, values, shortLabels) {
    var i, _i, _results;
    if (shortLabels == null) {
      shortLabels = false;
    }
    if (!shortLabels) {
      _results = [];
      for (i = _i = 0; 0 <= n ? _i < n : _i > n; i = 0 <= n ? ++_i : --_i) {
        _results.push(labeledInput(labels[i], values[i]));
      }
      return _results;
    } else {
      return [
        html.table({
          "class": "param-composite-table"
        }, html.thead({
          "class": "param-composite-thead"
        }, html.tr.apply(html, [{
          "class": "param-composite-thead-tr"
        }].concat(__slice.call((function() {
          var _j, _results1;
          _results1 = [];
          for (i = _j = 0; 0 <= n ? _j < n : _j > n; i = 0 <= n ? ++_j : --_j) {
            _results1.push(html.th({
              "class": "param-composite-th"
            }, labeledElements(labels[i])));
          }
          return _results1;
        })())))), html.tbody({
          "class": "param-composite-tbody"
        }, html.tr.apply(html, [{
          "class": "param-composite-tr"
        }].concat(__slice.call((function() {
          var _j, _results1;
          _results1 = [];
          for (i = _j = 0; 0 <= n ? _j < n : _j > n; i = 0 <= n ? ++_j : --_j) {
            _results1.push(html.td({
              "class": "param-composite-td"
            }, html.input({
              "class": "param-input",
              type: 'text',
              value: String(values[i])
            })));
          }
          return _results1;
        })())))))
      ];
    }
  };
  labeledTolerance = function(label, tolerance) {
    return [
      html.th({
        "class": "param-tolerance-th",
        scope: "row"
      }, html.label({
        "class": "param-label"
      }, label)), html.td(html.input({
        "class": "param-input",
        type: 'text',
        value: String(tolerance.min)
      })), html.td(html.input({
        "class": "param-input",
        type: 'text',
        value: String(tolerance.max)
      }))
    ];
  };
  labeledCompositeTolerance = function(n, labels, tolerances) {
    var i, _i, _results;
    _results = [];
    for (i = _i = 0; 0 <= n ? _i < n : _i > n; i = 0 <= n ? ++_i : --_i) {
      _results.push(labeledTolerance(labels[i], {
        min: tolerances.min[i],
        max: tolerances.max[i]
      }));
    }
    return _results;
  };
  toleranceHTML = adt({
    real: function(id, meta, defaultTolerance) {
      var _ref;
      if (typeof meta === 'string') {
        meta = {
          label: meta
        };
      } else if (!(meta != null)) {
        meta = {
          label: id
        };
      } else if (!(meta.label != null)) {
        meta.label = id;
      }
      if ((_ref = meta.description) == null) {
        meta.description = "";
      }
      return html.tr.apply(html, [{
        "class": "parameter param-numeric param-real",
        title: escapeAttrib(meta.description)
      }].concat(__slice.call(labeledTolerance(meta.label, defaultTolerance))));
    },
    dimension1: function(id, meta, defaultTolerance) {
      var _ref;
      if (typeof meta === 'string') {
        meta = {
          label: meta
        };
      } else if (!(meta != null)) {
        meta = {
          label: id
        };
      } else if (!(meta.label != null)) {
        meta.label = id;
      }
      if ((_ref = meta.description) == null) {
        meta.description = "";
      }
      return html.tr.apply(html, [{
        "class": "parameter param-numeric param-dimension1",
        title: escapeAttrib(meta.description)
      }].concat(__slice.call(labeledTolerance(meta.label, defaultTolerance))));
    },
    dimension2: function(id, meta, defaultTolerance) {
      var tds, trs, _ref, _ref1;
      if (typeof meta === 'string') {
        meta = {
          label: meta
        };
      } else if (!(meta != null)) {
        meta = {};
      }
      if ((_ref = meta.description) == null) {
        meta.description = "";
      }
      if ((_ref1 = meta.components) == null) {
        meta.components = ["X", "Y"];
      }
      if (!Array.isArray(defaultTolerance.min)) {
        defaultTolerance.min = [defaultTolerance.min, defaultTolerance.min, defaultTolerance.min];
      }
      if (!Array.isArray(defaultTolerance.max)) {
        defaultTolerance.max = [defaultTolerance.max, defaultTolerance.max, defaultTolerance.max];
      }
      trs = !(meta.label != null) ? [] : [
        html.tr(html.th({
          "class": "param-composite-label",
          colspan: 3,
          scope: "rowgroup"
        }, escapeAttrib(meta.label)))
      ];
      trs = trs.concat((function() {
        var _i, _len, _ref2, _results;
        _ref2 = labeledCompositeTolerance(2, meta.components, defaultTolerance);
        _results = [];
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          tds = _ref2[_i];
          _results.push(html.tr.apply(html, [{
            "class": "param-numeric"
          }].concat(__slice.call(tds))));
        }
        return _results;
      })());
      return html.tbody.apply(html, [{
        "class": "parameter param-composite param-dimension2",
        title: escapeAttrib(meta.description)
      }].concat(__slice.call(trs)));
    },
    dimension3: function(id, meta, defaultTolerance) {
      var tds, trs, _ref, _ref1;
      if (typeof meta === 'string') {
        meta = {
          label: meta
        };
      } else if (!(meta != null)) {
        meta = {
          label: id
        };
      } else if (!(meta.label != null)) {
        meta.label = id;
      }
      if ((_ref = meta.description) == null) {
        meta.description = "";
      }
      if ((_ref1 = meta.components) == null) {
        meta.components = ["X", "Y", "Z"];
      }
      if (!Array.isArray(defaultTolerance.min)) {
        defaultTolerance.min = [defaultTolerance.min, defaultTolerance.min, defaultTolerance.min];
      }
      if (!Array.isArray(defaultTolerance.max)) {
        defaultTolerance.max = [defaultTolerance.max, defaultTolerance.max, defaultTolerance.max];
      }
      trs = !(meta.label != null) ? [] : [
        html.tr(html.th({
          "class": "param-composite-label",
          colspan: 3,
          scope: "rowgroup"
        }, escapeAttrib(meta.label)))
      ];
      trs = trs.concat((function() {
        var _i, _len, _ref2, _results;
        _ref2 = labeledCompositeTolerance(3, meta.components, defaultTolerance);
        _results = [];
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          tds = _ref2[_i];
          _results.push(html.tr.apply(html, [{
            "class": "param-numeric"
          }].concat(__slice.call(tds))));
        }
        return _results;
      })());
      return html.tbody.apply(html, [{
        "class": "parameter param-composite param-dimension3",
        title: escapeAttrib(meta.description)
      }].concat(__slice.call(trs)));
    },
    vector2: function() {
      throw "Unsupported tolerance type `" + this._tag + "` (TODO)";
    },
    vector3: function() {
      throw "Unsupported tolerance type `" + this._tag + "` (TODO)";
    },
    point2: function() {
      throw "Unsupported tolerance type `" + this._tag + "` (TODO)";
    },
    point3: function() {
      throw "Unsupported tolerance type `" + this._tag + "` (TODO)";
    },
    pitch1: function() {
      throw "Unsupported tolerance type `" + this._tag + "` (TODO)";
    },
    pitch2: function() {
      throw "Unsupported tolerance type `" + this._tag + "` (TODO)";
    },
    pitch3: function() {
      throw "Unsupported tolerance type `" + this._tag + "` (TODO)";
    },
    angle: function() {
      throw "Unsupported tolerance type `" + this._tag + "` (TODO)";
    },
    polar: function() {
      throw "Unsupported tolerance type `" + this._tag + "` (TODO)";
    },
    cylindrical: function() {
      throw "Unsupported tolerance type `" + this._tag + "` (TODO)";
    },
    spherical: function() {
      throw "Unsupported tolerance type `" + this._tag + "` (TODO)";
    },
    _: function() {
      throw "Unsupported tolerance type `" + this._tag + "`";
    }
  });
  resolveMeta = function(id, meta) {
    var _ref, _ref1;
    if (typeof meta === 'string') {
      meta = {
        label: meta
      };
    } else if (!(meta != null)) {
      meta = {
        label: id
      };
    } else {
      if ((_ref = meta.label) == null) {
        meta.label = id;
      }
    }
    if ((_ref1 = meta.description) == null) {
      meta.description = "";
    }
    return meta;
  };
  return module.exports = adt({
    parameters: function() {
      var children, description;
      description = arguments[0], children = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return html.div.apply(html, [{
        "class": "parameters"
      }].concat(__slice.call(adt.map(this, children))));
    },
    section: function() {
      var children, heading;
      heading = arguments[0], children = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return html.section.apply(html, [{
        "class": "param-section"
      }, html.h1({
        "class": "param-heading",
        title: escapeAttrib(heading)
      }, String(heading))].concat(__slice.call(adt.map(this, groupByTolerance(children)))));
    },
    real: function(id, meta, defaultValue) {
      meta = resolveMeta(id, meta);
      return wrap(html.div({
        "class": "param-numeric param-real",
        title: escapeAttrib(meta.description)
      }, html.label({
        "class": "param-label"
      }, html.span({
        "class": "param-label-text"
      }, String(meta.label)), html.input({
        "class": "param-input",
        type: 'text',
        value: String(defaultValue)
      }))));
    },
    dimension1: function(id, meta, defaultValue) {
      meta = resolveMeta(id, meta);
      return wrap(html.div({
        "class": "param-numeric param-dimension1",
        title: escapeAttrib(meta.description)
      }, html.label({
        "class": "param-label"
      }, html.span({
        "class": "param-label-text"
      }, String(meta.label)), html.input({
        "class": "param-input",
        type: 'text',
        value: String(defaultValue)
      }))));
    },
    dimension2: function(id, meta, defaultValue) {
      var shortLabels, _ref;
      meta = resolveMeta(id, meta);
      if ((_ref = meta.components) == null) {
        meta.components = ["X", "Y"];
      }
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length) < shortLabelLength;
      if (!Array.isArray(defaultValue)) {
        defaultValue = [defaultValue, defaultValue];
      }
      return wrapComposite.apply(null, ["param-numeric param-dimension2", meta.description, html.label({
        "class": "param-composite-label"
      }, html.span({
        "class": "param-label-text"
      }, String(meta.label)))].concat(__slice.call(labeledInputs(2, meta.components, defaultValue, shortLabels))));
    },
    dimension3: function(id, meta, defaultValue) {
      var shortLabels, _ref;
      meta = resolveMeta(id, meta);
      if ((_ref = meta.components) == null) {
        meta.components = ["X", "Y", "Z"];
      }
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length, meta.components[2].length) < shortLabelLength;
      if (!Array.isArray(defaultValue)) {
        defaultValue = [defaultValue, defaultValue, defaultValue];
      }
      return wrapComposite.apply(null, ["param-numeric param-dimension3", meta.description, html.label({
        "class": "param-composite-label"
      }, html.span({
        "class": "param-label-text"
      }, String(meta.label)))].concat(__slice.call(labeledInputs(3, meta.components, defaultValue, shortLabels))));
    },
    vector2: function(id, meta, defaultValue) {
      var shortLabels, _ref;
      meta = resolveMeta(id, meta);
      if ((_ref = meta.components) == null) {
        meta.components = ["X", "Y"];
      }
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length) < shortLabelLength;
      if (!Array.isArray(defaultValue)) {
        defaultValue = [defaultValue, defaultValue];
      }
      return wrapComposite.apply(null, ["param-numeric param-vector2", meta.description, html.label({
        "class": "param-composite-label"
      }, html.span({
        "class": "param-label-text"
      }, String(meta.label)))].concat(__slice.call(labeledInputs(2, meta.components, defaultValue, shortLabels))));
    },
    vector3: function(id, meta, defaultValue) {
      var shortLabels, _ref;
      meta = resolveMeta(id, meta);
      if ((_ref = meta.components) == null) {
        meta.components = ["X", "Y", "Z"];
      }
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length, meta.components[2].length) < shortLabelLength;
      if (!Array.isArray(defaultValue)) {
        defaultValue = [defaultValue, defaultValue, defaultValue];
      }
      return wrapComposite.apply(null, ["param-numeric param-vector3", meta.description, html.label({
        "class": "param-composite-label"
      }, html.span({
        "class": "param-label-text"
      }, String(meta.label)))].concat(__slice.call(labeledInputs(3, meta.components, defaultValue, shortLabels))));
    },
    point2: function(id, meta, defaultValue) {
      var shortLabels, _ref;
      meta = resolveMeta(id, meta);
      if ((_ref = meta.components) == null) {
        meta.components = ["X", "Y"];
      }
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length) < shortLabelLength;
      if (!Array.isArray(defaultValue)) {
        defaultValue = [defaultValue, defaultValue];
      }
      return wrapComposite.apply(null, ["param-numeric param-point2", meta.description, html.label({
        "class": "param-composite-label"
      }, html.span({
        "class": "param-label-text"
      }, String(meta.label)))].concat(__slice.call(labeledInputs(2, meta.components, defaultValue, shortLabels))));
    },
    point3: function(id, meta, defaultValue) {
      var shortLabels, _ref;
      meta = resolveMeta(id, meta);
      if ((_ref = meta.components) == null) {
        meta.components = ["X", "Y", "Z"];
      }
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length, meta.components[2].length) < shortLabelLength;
      if (!Array.isArray(defaultValue)) {
        defaultValue = [defaultValue, defaultValue, defaultValue];
      }
      return wrapComposite.apply(null, ["param-numeric param-point3", meta.description, html.label({
        "class": "param-composite-label"
      }, html.span({
        "class": "param-label-text"
      }, String(meta.label)))].concat(__slice.call(labeledInputs(3, meta.components, defaultValue, shortLabels))));
    },
    pitch1: function(id, meta, defaultValue) {
      meta = resolveMeta(id, meta);
      return wrap(html.div({
        "class": "param-numeric param-pitch1",
        title: escapeAttrib(meta.description)
      }, html.label({
        "class": "param-label"
      }, html.span({
        "class": "param-label-text"
      }, String(meta.label)), html.input({
        "class": "param-input",
        type: 'text',
        value: String(defaultValue)
      }))));
    },
    pitch2: function(id, meta, defaultValue) {
      var shortLabels, _ref;
      meta = resolveMeta(id, meta);
      if ((_ref = meta.components) == null) {
        meta.components = ["X", "Y"];
      }
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length) < shortLabelLength;
      if (!Array.isArray(defaultValue)) {
        defaultValue = [defaultValue, defaultValue];
      }
      return wrapComposite.apply(null, ["param-numeric param-pitch2", meta.description, html.label({
        "class": "param-composite-label"
      }, html.span({
        "class": "param-label-text"
      }, String(meta.label)))].concat(__slice.call(labeledInputs(2, meta.components, defaultValue, shortLabels))));
    },
    pitch3: function(id, meta, defaultValue) {
      var shortLabels, _ref;
      meta = resolveMeta(id, meta);
      if ((_ref = meta.components) == null) {
        meta.components = ["X", "Y", "Z"];
      }
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length, meta.components[2].length) < shortLabelLength;
      if (!Array.isArray(defaultValue)) {
        defaultValue = [defaultValue, defaultValue, defaultValue];
      }
      return wrapComposite.apply(null, ["param-numeric param-pitch3", meta.description, html.label({
        "class": "param-composite-label"
      }, html.span({
        "class": "param-label-text"
      }, String(meta.label)))].concat(__slice.call(labeledInputs(3, meta.components, defaultValue, shortLabels))));
    },
    angle: function(id, meta, defaultValue) {
      throw "Unsupported parameter type `" + this._tag + "` (TODO)";
    },
    polar: function(id, meta, defaultValue) {
      throw "Unsupported parameter type `" + this._tag + "` (TODO)";
    },
    cylindrical: function(id, meta, defaultValue) {
      throw "Unsupported parameter type `" + this._tag + "` (TODO)";
    },
    spherical: function(id, meta, defaultValue) {
      throw "Unsupported parameter type `" + this._tag + "` (TODO)";
    },
    integer: function(id, meta, defaultValue) {
      throw "Unsupported parameter type `" + this._tag + "` (TODO)";
    },
    natural: function(id, meta, defaultValue) {
      throw "Unsupported parameter type `" + this._tag + "` (TODO)";
    },
    latice1: function(id, meta, defaultValue) {
      meta = resolveMeta(id, meta);
      return wrap(html.div({
        "class": "param-numeric param-latice1",
        title: escapeAttrib(meta.description)
      }, html.label({
        "class": "param-label"
      }, html.span({
        "class": "param-label-text"
      }, String(meta.label)), html.input({
        "class": "param-input",
        type: 'text',
        value: String(defaultValue)
      }))));
    },
    latice2: function(id, meta, defaultValue) {
      var shortLabels, _ref;
      meta = resolveMeta(id, meta);
      if ((_ref = meta.components) == null) {
        meta.components = ["X", "Y"];
      }
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length) < shortLabelLength;
      if (!Array.isArray(defaultValue)) {
        defaultValue = [defaultValue, defaultValue];
      }
      return wrapComposite.apply(null, ["param-numeric param-latice2", meta.description, html.label({
        "class": "param-composite-label"
      }, html.span({
        "class": "param-label-text"
      }, String(meta.label)))].concat(__slice.call(labeledInputs(2, meta.components, defaultValue, shortLabels))));
    },
    latice3: function(id, meta, defaultValue) {
      var shortLabels, _ref;
      meta = resolveMeta(id, meta);
      if ((_ref = meta.components) == null) {
        meta.components = ["X", "Y", "Z"];
      }
      shortLabels = Math.max(meta.components[0].length, meta.components[1].length, meta.components[2].length) < shortLabelLength;
      if (!Array.isArray(defaultValue)) {
        defaultValue = [defaultValue, defaultValue, defaultValue];
      }
      return wrapComposite.apply(null, ["param-numeric param-latice3", meta.description, html.label({
        "class": "param-composite-label"
      }, html.span({
        "class": "param-label-text"
      }, String(meta.label)))].concat(__slice.call(labeledInputs(3, meta.components, defaultValue, shortLabels))));
    },
    option: function(id, meta, options, defaultOption) {
      var k, keyValue, v, _ref;
      if (typeof meta === 'string') {
        meta = {
          label: meta
        };
      } else if (!(meta != null)) {
        meta = {
          label: id
        };
      } else if (!(meta.label != null)) {
        meta.label = id;
      }
      if ((_ref = meta.description) == null) {
        meta.description = "";
      }
      keyValue = {};
      options = (function() {
        var _i, _len, _results;
        if (Array.isArray(options)) {
          _results = [];
          for (_i = 0, _len = options.length; _i < _len; _i++) {
            k = options[_i];
            _results.push(keyValue[k] = k);
          }
          return _results;
        } else {
          return keyValue = options;
        }
      })();
      if (defaultOption == null) {
        defaultOption = (Object.keys(keyValue))[0];
      }
      return wrap(html.div({
        "class": "param-numeric param-real",
        title: escapeAttrib(meta.description)
      }, labeledElements(meta.label, html.select.apply(html, [{
        "class": "param-select"
      }].concat(__slice.call((function() {
        var _results;
        _results = [];
        for (k in keyValue) {
          v = keyValue[k];
          _results.push(html.option({
            value: k,
            selected: (k === defaultOption ? true : void 0)
          }, v));
        }
        return _results;
      })()))))));
    },
    boolean: function(id, meta, defaultValue) {
      var _ref;
      if (typeof meta === 'string') {
        meta = {
          label: meta
        };
      } else if (!(meta != null)) {
        meta = {
          label: id
        };
      } else if (!(meta.label != null)) {
        meta.label = id;
      }
      if ((_ref = meta.description) == null) {
        meta.description = "";
      }
      return wrap(html.div({
        "class": "param-boolean",
        title: escapeAttrib(meta.description)
      }, labeledElements(meta.label, html.input({
        "class": "param-checkbox",
        type: "checkbox"
      }))));
    },
    tolerance: function() {
      var i, ii, rowgroup, rowgroups, tbodies, tolerances, _i, _len;
      tolerances = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      if (tolerances.length === 0) {
        return;
      }
      rowgroups = adt.map(toleranceHTML, tolerances);
      tbodies = [];
      ii = NaN;
      for (i = _i = 0, _len = rowgroups.length; _i < _len; i = ++_i) {
        rowgroup = rowgroups[i];
        if (rowgroup._tag === "tr") {
          if (ii === i - 1) {
            tbodies[tbodies.length - 1].push(rowgroup);
          } else {
            tbodies.push(html.tbody({
              "class": ""
            }, rowgroup));
          }
          ii = i;
        } else {
          tbodies.push(rowgroup);
        }
      }
      return html.div({
        "class": "parameter-set"
      }, html.table.apply(html, [{
        "class": "param-tolerance-table"
      }, html.thead({
        "class": "param-tolerance-thead"
      }, html.tr({
        "class": "param-tolerance-legend"
      }, html.th({
        "class": "param-tolerance-th"
      }), html.th({
        "class": "param-tolerance-th"
      }, "Min"), html.th({
        "class": "param-tolerance-th"
      }, "Max")))].concat(__slice.call(tbodies))));
    },
    range: function(id, meta, defaultValue, range) {
      throw "Unsupported parameter type `" + this._tag + "` (TODO)";
    },
    _: function() {
      throw "Unsupported parameter type `" + this._tag + "`";
    }
  });
})(typeof adt !== "undefined" && adt !== null ? adt : require('adt.js'), typeof html !== "undefined" && html !== null ? html : require('adt-html.js'));
}, "parameterize-form.js": function(exports, require, module) {// Generated by CoffeeScript 1.4.0

(function(adt) {
  var form;
  form = {
    html: require("html")
  };
  form.form = adt.constructors(form.html);
  form.get = function(formElement) {};
  form.set = function(formElement, form) {};
  form.on = function(eventKey, callback) {};
  return module.exports = form;
})(typeof adt !== "undefined" && adt !== null ? adt : require('adt.js'));
}});

// Assign this library to a global variable if a global variable is defined
var parameterizeExports = this.require("parameterize-form");
parameterize.form = parameterizeExports.form;
parameterize.html = parameterizeExports.html;
// Restore the original require method
if (typeof originalRequire === 'undefined')
  delete this.require;
else
  this.require = originalRequire;
})();

