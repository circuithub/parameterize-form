
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
  var escapeAttrib, toleranceHTML, wrap;
  wrap = function() {
    return html.div.apply(html, [{
      "class": 'parameter'
    }].concat(__slice.call(arguments)));
  };
  escapeAttrib = function(str) {
    return (String(str)).replace(/['"]/gi, "`");
  };
  toleranceHTML = adt({
    real: function(label, description, defaultTolerance) {
      return wrap(html.div({
        "class": "param-real",
        title: escapeAttrib(description)
      }, html.label({
        "class": "param-label"
      }, html.span({
        "class": "param-label-text"
      }, String(label)), html.span({
        "class": "param-real param-tolerance-min"
      }, html.input({
        "class": "param-input",
        value: String(defaultTolerance.min)
      })), html.span({
        "class": "param-real param-tolerance-max"
      }, html.input({
        "class": "param-input",
        value: String(defaultTolerance.max)
      })))));
    },
    _: function() {
      throw "Unsupported tolerance type `" + this._tag + "`";
    }
  });
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
      return wrap(html.section.apply(html, [{
        "class": "param-section"
      }, html.h2({
        "class": "param-header"
      }, String(heading))].concat(__slice.call(adt.map(this, children)))));
    },
    real: function(label, description, defaultValue) {
      return wrap(html.div({
        "class": "param-real",
        title: escapeAttrib(description)
      }, html.label({
        "class": "param-label"
      }, html.span({
        "class": "param-label-text"
      }, String(label)), html.input({
        "class": "param-input",
        value: String(defaultValue)
      }))));
    },
    option: function(label, description, options, defaultOption) {
      var k, keyValue, v;
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
        "class": "param-real",
        title: escapeAttrib(description)
      }, html.label({
        "class": "param-label"
      }, html.span({
        "class": "param-label-text"
      }, String(label)), html.select.apply(html, [{
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
    boolean: function(label, description, defaultValue) {
      return wrap(html.div({
        "class": "param-boolean",
        title: escapeAttrib(description)
      }, html.label({
        "class": "param-label"
      }, html.input({
        type: "checkbox",
        "class": "param-checkbox"
      }), html.span(String(label)))));
    },
    tolerances: function() {
      var tolerances;
      tolerances = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return html.div({
        "class": "param-tolerance-table"
      }, html.div({
        "class": "param-tolerance-legend"
      }, html.span({
        "class": "param-tolerance-legend-label"
      }, "Min"), html.span({
        "class": "param-tolerance-legend-label"
      }, "Max")), html.div.apply(html, [{
        "class": "param-tolerance-body"
      }].concat(__slice.call(adt.map(toleranceHTML, tolerances)))));
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
